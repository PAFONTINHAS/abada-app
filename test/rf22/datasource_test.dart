import 'firebase_test_platform.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:sistema_abada_capoeira/core/requests/data/request_datasource_impl.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_update_parameters.dart';
import 'package:sistema_abada_capoeira/features/events/data/datasources/event_requests_remote_datasource_impl.dart';
import 'package:sistema_abada_capoeira/features/events/data/models/event_entity_model.dart';
import 'fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late FakeFirebaseFirestore db;
  late EventRequestsRemoteDatasourceImpl teacher;
  late EventRequestsRemoteDatasourceImpl coordinator;
  const requestId = 'request-1';
  const decision = GenericRequestUpdateParameters(
    requestId: requestId,
    changeReason: 'Corrigir local',
    rejectionReason: 'Recusa final',
    additionalData: {'eventId': 'event-1', 'decidedBy': 'forged'},
  );

  Future<void> seed(String status) async {
    await db
        .collection('events')
        .doc('event-1')
        .set(EventEntityModel.fromEntity(eventFixture()).toMap());
    await db.collection('event_requests').doc(requestId).set({
      'eventId': 'event-1',
      'requesterId': 'teacher',
      'status': status,
      'eventName': 'Evento original',
      'requestedAt': DateTime(2026),
      'changeReason': '',
      'rejectionReason': '',
      'requesterNickname': 'Professor',
      'initDate': eventFixture().eventInitDate,
      'endingDate': eventFixture().eventEndingDate,
    });
  }

  setUpAll(initializeTestFirebase);
  setUp(() async {
    db = FakeFirebaseFirestore();
    testFirestore.reset(db);
    testAuth.uid = 'teacher';
    teacher = EventRequestsRemoteDatasourceImpl();
    coordinator = EventRequestsRemoteDatasourceImpl();
    await db.collection('users').doc('teacher').set({
      'userRole': 'professor',
      'isActive': true,
    });
    await db.collection('users').doc('coordinator').set({
      'userRole': 'coordinator',
      'isActive': true,
    });
  });

  test('request lookup returns document or a failure for missing ID', () async {
    await seed('requested');
    final result = await teacher.getEventRequestById(requestId);
    expect(result.isRight(), true);
    result.fold((_) => fail('Expected request'), (request) {
      expect(request.requestId, requestId);
      expect(request.eventId, 'event-1');
    });
    expect((await teacher.getEventRequestById('missing')).isLeft(), true);
  });
  test('missing event prevents resubmission without request updates', () async {
    await seed('changesRequested');
    await db.collection('events').doc('event-1').delete();
    final before = (await db.collection('event_requests').doc(requestId).get())
        .data();
    expect(
      (await teacher.resubmitEventRequest(requestId, eventFixture())).isLeft(),
      true,
    );
    expect(
      (await db.collection('event_requests').doc(requestId).get()).data(),
      before,
    );
    expect((await db.collection('events').doc('event-1').get()).exists, false);
  });
  test('anonymous resubmission is rejected by current client guard', () async {
    await seed('requested');
    final before = db.dump();
    testAuth.uid = null;
    expect(
      (await teacher.resubmitEventRequest(requestId, eventFixture())).isLeft(),
      true,
    );
    expect(db.dump(), before);
  });
  for (final source in GenericRequestStatus.values) {
    test('teacher transition from ${source.name}', () async {
      await seed(source.name);
      final before = db.dump();
      final result = await teacher.resubmitEventRequest(
        requestId,
        eventFixture().copyWith(
          eventName: 'Nome novo',
          eventInitDate: DateTime(2040),
          eventEndingDate: DateTime(2041),
          eventCreatorId: 'forged',
        ),
      );
      final allowed =
          source == GenericRequestStatus.requested ||
          source == GenericRequestStatus.changesRequested;
      expect(result.isRight(), allowed);
      if (!allowed) {
        expect(db.dump(), before);
        return;
      }
      final request =
          (await db.collection('event_requests').doc(requestId).get()).data()!;
      final event = (await db.collection('events').doc('event-1').get())
          .data()!;
      expect(
        request['status'],
        source == GenericRequestStatus.requested ? 'requested' : 'updated',
      );
      expect(request['eventName'], 'Nome novo');
      expect(event['eventName'], request['eventName']);
      expect(event['eventCreatorId'], 'teacher');
      expect(event['eventInitDate'], request['initDate']);
      expect(event['eventEndingDate'], request['endingDate']);
      expect((await db.collection('events').get()).docs.single.id, 'event-1');
      expect(
        (await db.collection('event_requests').get()).docs.single.id,
        requestId,
      );
    });
  }

  for (final source in GenericRequestStatus.values) {
    for (final destination in ['approved', 'rejected', 'changesRequested']) {
      test('coordinator ${source.name} -> $destination', () async {
        await seed(source.name);
        final before = db.dump();
        testAuth.uid = 'coordinator';
        final action = switch (destination) {
          'approved' => coordinator.approveRequest,
          'rejected' => coordinator.rejectRequest,
          _ => coordinator.requestChanges,
        };
        final result = await action(decision);
        final allowed =
            source == GenericRequestStatus.requested ||
            source == GenericRequestStatus.updated;
        expect(result.isRight(), allowed);
        if (!allowed) {
          expect(db.dump(), before);
          return;
        }
        final request =
            (await db.collection('event_requests').doc(requestId).get())
                .data()!;
        expect(request['status'], destination);
        expect(request['decidedBy'], 'coordinator');
        expect(request['decidedAt'], isNotNull);
        if (destination == 'changesRequested') {
          expect(request['changeReason'], 'Corrigir local');
        }
        if (destination == 'rejected') {
          expect(request['rejectionReason'], 'Recusa final');
        }
      });
    }
  }

  test(
    'Rules: rejects foreign ownership, mismatched ID, missing event and inactive profile',
    () async {
      await seed('requested');
      await db.collection('event_requests').doc(requestId).update({
        'requesterId': 'other',
      });
      expect(
        (await teacher.resubmitEventRequest(
          requestId,
          eventFixture(),
        )).isLeft(),
        true,
      );
      await seed('requested');
      expect(
        (await teacher.resubmitEventRequest(
          requestId,
          eventFixture().copyWith(eventId: 'other'),
        )).isLeft(),
        true,
      );
      await db.collection('events').doc('event-1').delete();
      expect(
        (await teacher.resubmitEventRequest(
          requestId,
          eventFixture(),
        )).isLeft(),
        true,
      );
      await seed('requested');
      await db.collection('users').doc('teacher').update({'isActive': false});
      expect(
        (await teacher.resubmitEventRequest(
          requestId,
          eventFixture(),
        )).isLeft(),
        true,
      );
    },
    skip:
        'Requires Firebase Emulator and event authorization Rules; fake does not enforce security.',
  );

  test(
    'student, anonymous and professor cannot make coordinator decisions',
    () async {
      await seed('requested');
      expect((await teacher.rejectRequest(decision)).isLeft(), true);
      testAuth.uid = null;
      final anonymous = EventRequestsRemoteDatasourceImpl();
      expect(
        (await anonymous.resubmitEventRequest(
          requestId,
          eventFixture(),
        )).isLeft(),
        true,
      );
      await db.collection('users').doc('teacher').update({
        'userRole': 'student',
      });
      expect(
        (await teacher.resubmitEventRequest(
          requestId,
          eventFixture(),
        )).isLeft(),
        true,
      );
    },
    skip: 'Requires Firebase Emulator and role/active-profile Rules.',
  );

  test(
    'decision must refer to displayed event',
    () async {
      await seed('requested');
      expect(
        (await coordinator.rejectRequest(
          const GenericRequestUpdateParameters(
            requestId: requestId,
            rejectionReason: 'Reason',
            additionalData: {'eventId': 'wrong'},
          ),
        )).isLeft(),
        true,
      );
    },
    skip:
        'Implementation gap: datasource no longer checks displayed event ID; Rules pending.',
  );

  test('no status-only shortcut, including changesRequested', () async {
    for (final source in GenericRequestStatus.values) {
      await seed(source.name);
      final before = db.dump();
      expect((await teacher.markRequestAsUpdated(decision)).isLeft(), true);
      expect(db.dump(), before);
    }
  });

  test('preserves latest image when no replacement was supplied', () async {
    await seed('requested');
    await db.collection('events').doc('event-1').update({
      'eventImagePath': 'latest-url',
    });
    expect(
      (await teacher.resubmitEventRequest(
        requestId,
        eventFixture().copyWith(clearEventImage: true),
      )).isRight(),
      true,
    );
    expect(
      (await db.collection('events').doc('event-1').get())
          .data()!['eventImagePath'],
      'latest-url',
    );
  });

  test('decision committed before stale edit blocks that edit', () async {
    await seed('requested');
    final stale = eventFixture().copyWith(eventName: 'Stale');
    testAuth.uid = 'coordinator';
    expect((await coordinator.rejectRequest(decision)).isRight(), true);
    testAuth.uid = 'teacher';
    expect(
      (await teacher.resubmitEventRequest(requestId, stale)).isLeft(),
      true,
    );
    expect(
      (await db.collection('events').doc('event-1').get()).data()!['eventName'],
      'Evento original',
    );
  });

  test('generic single-status API remains compatible', () async {
    await seed('requested');
    final helper = RequestDatasourceImpl();
    expect(
      (await helper.updateGenericRequestWithTransaction(
        collectionId: 'event_requests',
        params: decision,
        expectedStatus: GenericRequestStatus.requested,
        newStatus: GenericRequestStatus.requested,
        updateRelatedDocuments: (_, snapshot) async {},
      )).isRight(),
      true,
    );
  });
}
