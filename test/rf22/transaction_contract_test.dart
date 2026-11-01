import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_abada_capoeira/core/requests/data/request_datasource_impl.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_update_parameters.dart';
import 'package:sistema_abada_capoeira/features/events/data/datasources/event_requests_remote_datasource_impl.dart';
import 'package:sistema_abada_capoeira/features/events/data/models/event_entity_model.dart';
import 'fixtures.dart';

// fake_cloud_firestore does not simulate atomic commits or native retries.
// This harness verifies our callback contract, not the Firebase conflict engine.
class BufferedTransaction implements Transaction {
  final writes = <Future<void> Function()>[];
  @override
  Future<DocumentSnapshot<T>> get<T extends Object?>(
    DocumentReference<T> ref,
  ) => ref.get();
  @override
  Transaction update(DocumentReference ref, Map<Object, Object?> data) {
    writes.add(() => ref.update(data));
    return this;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class TransactionHarness implements FirebaseFirestore {
  final FakeFirebaseFirestore db;
  Future<void> Function()? beforeRetry;
  int attempts = 0;
  TransactionHarness(this.db);
  @override
  CollectionReference<Map<String, dynamic>> collection(String path) =>
      db.collection(path);
  @override
  Future<T> runTransaction<T>(
    TransactionHandler<T> handler, {
    Duration timeout = const Duration(seconds: 30),
    int maxAttempts = 5,
  }) async {
    while (true) {
      attempts++;
      final transaction = BufferedTransaction();
      final result = await handler(transaction);
      final retry = beforeRetry;
      beforeRetry = null;
      if (retry != null) {
        await retry();
        continue;
      }
      for (final write in transaction.writes) {
        await write();
      }
      await Future<void>.delayed(Duration.zero);
      return result;
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'callback failure after queuing event write leaves both documents intact',
    () async {
      final db = FakeFirebaseFirestore();
      await db.collection('events').doc('event-1').set({
        'eventName': 'Original',
      });
      await db.collection('event_requests').doc('request-1').set({
        'status': 'requested',
      });
      final before = db.dump();
      final helper = RequestDatasourceImpl(firestore: TransactionHarness(db));
      final result = await helper.updateGenericRequestWithTransaction(
        collectionId: 'event_requests',
        params: const GenericRequestUpdateParameters(requestId: 'request-1'),
        expectedStatus: GenericRequestStatus.requested,
        newStatus: GenericRequestStatus.requested,
        updateRelatedDocuments: (transaction, request) async {
          transaction.update(db.collection('events').doc('event-1'), {
            'eventName': 'Partial',
          });
          throw StateError('Failure before request update');
        },
      );
      expect(result.isLeft(), true);
      expect(db.dump(), before);
    },
  );

  test(
    'retry rereads status and cannot overwrite a concurrent terminal decision',
    () async {
      for (final terminal in ['approved', 'rejected']) {
        final db = FakeFirebaseFirestore();
        await db
            .collection('events')
            .doc('event-1')
            .set(EventEntityModel.fromEntity(eventFixture()).toMap());
        await db.collection('event_requests').doc('request-1').set({
          'status': 'requested',
          'eventId': 'event-1',
          'requesterId': 'teacher',
        });
        await db.collection('users').doc('teacher').set({
          'userRole': 'professor',
          'isActive': true,
        });
        final harness = TransactionHarness(db)
          ..beforeRetry = () async {
            await db.collection('event_requests').doc('request-1').update({
              'status': terminal,
            });
          };
        final datasource = EventRequestsRemoteDatasourceImpl(
          firestore: harness,
          auth: MockFirebaseAuth(
            signedIn: true,
            mockUser: MockUser(uid: 'teacher'),
          ),
        );
        expect(
          (await datasource.resubmitEventRequest(
            'request-1',
            eventFixture().copyWith(eventName: 'Stale edit'),
          )).isLeft(),
          true,
        );
        expect(harness.attempts, 2);
        expect(
          (await db.collection('events').doc('event-1').get())
              .data()!['eventName'],
          'Evento original',
        );
        expect(
          (await db.collection('event_requests').doc('request-1').get())
              .data()!['status'],
          terminal,
        );
      }
    },
  );
}
