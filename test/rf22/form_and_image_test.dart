import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/get_event_request_by_id_usecase.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/utils/generator.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/create_event_request_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/resubmit_event_request_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/get_event_by_id_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_products_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_phases_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_graduation_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_details_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/models/event_phases.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/request_item_card.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/existing_event_image_widget.dart';
import 'fixtures.dart';

EventRequestEntity requestFixture(GenericRequestStatus status) =>
    EventRequestEntity(
      eventId: 'event-1',
      requestId: 'request-1',
      requesterId: 'teacher',
      requestedAt: DateTime(2026),
      initDate: DateTime(2027),
      endingDate: DateTime(2027, 1, 2),
      eventName: 'Evento original',
      requesterNickname: 'Professor',
      status: status,
      changeReason: 'Corrigir o local',
    );

class DelayedRepository extends RepositoryStub {
  final pending = <String, Completer<Either<Failure, EventEntity>>>{};
  @override
  Future<Either<Failure, EventEntity>> getEventById(
    String eventId, {
    bool serverOnly = false,
  }) => (pending[eventId] = Completer()).future;
}

class CreationRepository extends RepositoryStub {
  int eventsCreated = 0;
  int requestsCreated = 0;
  @override
  Future<Either<Failure, EventEntity>> createEvent(EventEntity event) async {
    eventsCreated++;
    return Right(event.copyWith(eventId: 'new-event'));
  }

  @override
  Future<Either<Failure, EventRequestEntity>> createEventRequest(
    EventRequestEntity request,
  ) async {
    requestsCreated++;
    expect(request.eventId, 'new-event');
    return Right(request.copyWith(requestId: 'new-request'));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'creation still creates one event and its request; editing creates neither',
    () async {
      final repository = CreationRepository();
      final created = await CreateEventRequestUsecase(
        repository,
      ).call(eventFixture().copyWith(eventId: '', clearEventImage: true), null);
      expect(created.isRight(), true);
      expect(repository.eventsCreated, 1);
      expect(repository.requestsCreated, 1);
      await ResubmitEventRequestUsecase(
        repository,
      ).call('request-1', eventFixture(), null);
      expect(repository.eventsCreated, 1);
      expect(repository.requestsCreated, 1);
    },
  );

  test(
    'success feedback can use actual committed status instead of stale route status',
    () async {
      final repository = RepositoryStub()
        ..nextStatus = GenericRequestStatus.updated;
      final form = EventFormController(
        CreateEventRequestUsecase(repository),
        ResubmitEventRequestUsecase(repository),
      );
      addTearDown(form.dispose);
      form.loadEventForEditing(event: eventFixture(), requestId: 'request-1');
      expect(await form.resubmitEventRequest(eventFixture()), true);
      expect(form.savedStatus, GenericRequestStatus.updated);
    },
  );

  test(
    'definite rejection with failed server verification leaves upload untouched',
    () async {
      final repository = RepositoryStub()
        ..result = const Left(ValidationFailure('status rejected'))
        ..failRead = true;
      await ResubmitEventRequestUsecase(
        repository,
      ).call('request-1', eventFixture(), File('new.jpg'));
      expect(repository.deletedImages, isEmpty);
    },
  );
  test(
    'form restores base value, dates, image, products and resets state',
    () async {
      final repository = RepositoryStub();
      final form = EventFormController(
        CreateEventRequestUsecase(repository),
        ResubmitEventRequestUsecase(repository),
      );
      final products = EventProductsController();
      final graduation = EventGraduationController();
      final phases = EventFormPhasesController();
      addTearDown(() {
        form.dispose();
        products.dispose();
        graduation.dispose();
        phases.dispose();
      });
      final original = eventFixture();
      form.loadEventForEditing(event: original, requestId: 'request-1');
      products.loadProducts(original.products);
      graduation.loadGraduationSelection(
        selectedClass: null,
        selectedMemberIds: {'member-1'},
      );
      phases.nextFormPhase();
      expect(form.eventValue.text, '100.00');
      form.setEventInitDate(
        DateTime(2040),
        const TimeOfDay(hour: 0, minute: 0),
      );
      expect(form.eventInitDate, original.eventInitDate);
      final built = form.buildEventEntity(
        products: products.products,
        userId: 'other',
        userNickname: 'other',
        selectedMemberIds: graduation.selectedMemberIds,
        selectedClass: graduation.selectedClass,
      )!;
      expect(built.eventValue, '120.00');
      expect(built.eventId, original.eventId);
      expect(built.eventCreatorId, original.eventCreatorId);
      expect(form.existingImageUrl, original.eventImagePath);
      repository.result = const Left(NetworkFailure('offline'));
      form.eventName.text = 'Unsaved data';
      expect(
        await form.resubmitEventRequest(
          built.copyWith(eventName: 'Unsaved data'),
        ),
        false,
      );
      expect(form.eventName.text, 'Unsaved data');
      expect(products.products.single.product, 'Camisa');
      form.reset();
      products.reset();
      graduation.reset();
      phases.reset();
      expect(form.eventName.text, isEmpty);
      expect(form.requestId, isNull);
      expect(form.isEditing, false);
      expect(form.eventInitDate, isNull);
      expect(form.existingImageUrl, isNull);
      expect(products.products, isEmpty);
      expect(graduation.selectedMemberIds, isEmpty);
      expect(phases.currentPhase, EventPhases.firstPhase);
    },
  );

  test(
    'no image replacement sends preservation sentinel and never uploads',
    () async {
      final repository = RepositoryStub();
      final result = await ResubmitEventRequestUsecase(
        repository,
      ).call('request-1', eventFixture(), null);
      expect(result.isRight(), true);
      expect(repository.uploads, 0);
      expect(repository.submittedRequestId, 'request-1');
      expect(repository.submitted!.eventId, 'event-1');
      expect(repository.submitted!.eventImagePath, isNull);
    },
  );

  test(
    'new images are unique and failed transaction cleans only unreferenced upload',
    () async {
      final names = List.generate(
        1000,
        (_) => Generator.uniqueEventImageName(),
      );
      expect(names.toSet().length, names.length);
      final repository = RepositoryStub()
        ..result = const Left(ValidationFailure('status rejected'));
      final result = await ResubmitEventRequestUsecase(
        repository,
      ).call('request-1', eventFixture(), File('new.jpg'));
      expect(result.isLeft(), true);
      expect(
        repository.persisted.eventImagePath,
        eventFixture().eventImagePath,
      );
      expect(repository.deletedImages, [repository.uploadedUrl]);
    },
  );

  test(
    'ambiguous commit referencing upload and failed verification never delete it',
    () async {
      for (final readFails in [false, true]) {
        final repository = RepositoryStub()
          ..result = const Left(NetworkFailure('offline'))
          ..failRead = readFails;
        repository.persisted = eventFixture().copyWith(
          eventImagePath: repository.uploadedUrl,
        );
        await ResubmitEventRequestUsecase(
          repository,
        ).call('request-1', eventFixture(), File('new.jpg'));
        expect(repository.deletedImages, isEmpty);
      }
    },
  );

  test(
    'upload failure prevents writes and successful replacement retains old image',
    () async {
      final repository = RepositoryStub()..failUpload = true;
      final usecase = ResubmitEventRequestUsecase(repository);
      expect(
        (await usecase.call(
          'request-1',
          eventFixture(),
          File('new.jpg'),
        )).isLeft(),
        true,
      );
      expect(repository.submitted, isNull);
      repository.failUpload = false;
      expect(
        (await usecase.call(
          'request-1',
          eventFixture(),
          File('new.jpg'),
        )).isRight(),
        true,
      );
      expect(repository.deletedImages, isEmpty);
      expect(repository.submitted!.eventImagePath, repository.uploadedUrl);
    },
  );

  test('details clears old data and ignores out-of-order responses', () async {
    final repository = DelayedRepository();
    final controller = EventDetailsController(GetEventByIdUsecase(repository), GetEventRequestByIdUsecase(repository));
    addTearDown(controller.dispose);
    controller.setEventEntity(eventFixture());
    final a = controller.getEventById('a');
    expect(controller.eventEntity, isNull);
    expect(controller.isLoading, true);
    final b = controller.getEventById('b');
    repository.pending['b']!.complete(
      Right(eventFixture().copyWith(eventId: 'b')),
    );
    expect(await b, true);
    repository.pending['a']!.complete(
      Right(eventFixture().copyWith(eventId: 'a')),
    );
    expect(await a, false);
    expect(controller.eventEntity!.eventId, 'b');
  });

  test(
    'details requires valid request-event association before decisions',
    () async {
      final repository = RepositoryStub();
      final controller = EventDetailsController(
        GetEventByIdUsecase(repository),
        GetEventRequestByIdUsecase(repository),
      );
      addTearDown(controller.dispose);
      repository.request = repository.request.copyWith(eventId: 'wrong');
      expect(
        await controller.getEventById('event-1', requestId: 'request-1'),
        false,
      );
      expect(controller.canDecide('request-1', 'event-1'), false);
      repository.request = repository.request.copyWith(eventId: 'event-1');
      expect(
        await controller.getEventById('event-1', requestId: 'request-1'),
        true,
      );
      expect(controller.canDecide('request-1', 'event-1'), true);
      expect(controller.canDecide('other', 'event-1'), false);
    },
  );

  for (final status in GenericRequestStatus.values) {
    testWidgets('edit button for ${status.name}', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RequestItemCard(
              request: requestFixture(status),
              onViewEventDetails: () {},
              onViewRequestDetails: () {},
              onEditRequest: () {},
            ),
          ),
        ),
      );
      expect(
        find.text('Editar evento'),
        status == GenericRequestStatus.requested ||
                status == GenericRequestStatus.changesRequested
            ? findsOneWidget
            : findsNothing,
      );
    });
  }

  testWidgets('existing remote image has an accessible preview', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExistingEventImageWidget(url: 'https://example.test/image.jpg'),
        ),
      ),
    );
    final image = tester.widget<Image>(find.byType(Image));
    expect(image.image, isA<NetworkImage>());
    expect(image.semanticLabel, 'Imagem atual do evento');
    await tester.pump();
  });
}
