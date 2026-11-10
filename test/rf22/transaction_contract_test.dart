import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_test_platform.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_abada_capoeira/core/requests/data/request_datasource_impl.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_update_parameters.dart';
import 'package:sistema_abada_capoeira/features/events/data/datasources/event_requests_remote_datasource_impl.dart';
import 'package:sistema_abada_capoeira/features/events/data/models/event_entity_model.dart';
import 'fixtures.dart';

void main() {
  setUpAll(initializeTestFirebase);
  test(
    'failed commit discards event and request writes in test platform',
    () async {
      final db = FakeFirebaseFirestore();
      await db
          .collection('events')
          .doc('event-1')
          .set(EventEntityModel.fromEntity(eventFixture()).toMap());
      await db.collection('event_requests').doc('request-1').set({
        'status': 'changesRequested',
        'eventId': 'event-1',
        'requesterId': 'teacher',
      });
      testFirestore.reset(db);
      testFirestore.failCommit = true;
      testAuth.uid = 'teacher';
      final before = db.dump();
      final result = await EventRequestsRemoteDatasourceImpl()
          .resubmitEventRequest(
            'request-1',
            eventFixture().copyWith(eventName: 'Partial'),
          );
      expect(result.isLeft(), true);
      expect(db.dump(), before);
    },
  );
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
      testFirestore.reset(db);
      final helper = RequestDatasourceImpl();
      final result = await helper.updateGenericRequestWithTransaction(
        collectionId: 'event_requests',
        params: const GenericRequestUpdateParameters(requestId: 'request-1'),
        expectedStatus: GenericRequestStatus.requested,
        newStatus: GenericRequestStatus.requested,
        updateRelatedDocuments: (transaction, request) async {
          transaction.update(
            FirebaseFirestore.instance.collection('events').doc('event-1'),
            {'eventName': 'Partial'},
          );
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
        testFirestore.reset(db);
        testAuth.uid = "teacher";
        final harness = testFirestore
          ..beforeRetry = () async {
            await db.collection('event_requests').doc('request-1').update({
              'status': terminal,
            });
          };
        final datasource = EventRequestsRemoteDatasourceImpl();
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
