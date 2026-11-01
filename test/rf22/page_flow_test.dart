import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/router/routes/event_routes.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/create_event_request_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/resubmit_event_request_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/get_user_events_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/get_event_by_id_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/created_events_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_products_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_phases_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_graduation_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/models/event_phases.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/pages/event_form_page.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_navigation_bar_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/existing_event_image_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_controller.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_professor_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/acess_profile.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/tusca_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/tusca_status.dart';
import 'package:sistema_abada_capoeira/features/location/presentation/controllers/create_location_controller.dart';
import 'package:sistema_abada_capoeira/core/services/location_service/place_suggestion.dart';
import 'fixtures.dart';
import 'form_and_image_test.dart' show requestFixture;

class ProfileStub extends ChangeNotifier implements ProfileController {
  @override
  ProfileLoadStatus get status => ProfileLoadStatus.loaded;
  @override
  UserProfileEntity get userProfile => const UserProfileEntity(
    uid: 'teacher',
    fullName: 'Professor',
    email: 'teacher@example.test',
    phoneNumber: '',
    currentBelt: '',
    role: UserRole.professor,
    tusca: TuscaEntity(status: TuscaStatus.notApplicable),
    attendedClasses: [],
    lecturedClasses: [],
    isActive: true,
  );
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class ClassStub extends ChangeNotifier implements ClassController {
  @override
  List<ClassEntity> lecturedClasses = [];
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class LocationStub extends ChangeNotifier implements CreateLocationController {
  @override
  bool get isSearching => false;
  @override
  List<PlaceSuggestion> get suggestions => [];
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class ListRepository extends RepositoryStub {
  GenericRequestStatus status = GenericRequestStatus.changesRequested;
  int listReads = 0;
  @override
  Future<Either<Failure, List<EventEntity>>> getEventsByUserId(
    String userId,
  ) async => const Right([]);
  @override
  Future<Either<Failure, List<EventRequestEntity>>>
  getPendingEventsRequestsByUserId(String userId) async {
    listReads++;
    return Right([
      requestFixture(status).copyWith(eventName: persisted.eventName),
    ]);
  }

  @override
  Future<Either<Failure, GenericRequestStatus>> resubmitEventRequest(
    String requestId,
    EventEntity event,
  ) async {
    if (result.isRight()) {
      persisted = event;
      if (status == GenericRequestStatus.changesRequested) {
        status = GenericRequestStatus.updated;
      }
    }
    nextStatus = status;
    return super.resubmitEventRequest(requestId, event);
  }
}

void main() {
  testWidgets('replacement class removes the stale missing-class block', (
    tester,
  ) async {
    final repository = RepositoryStub()
      ..result = const Left(NetworkFailure('offline'));
    final form = EventFormController(
      CreateEventRequestUsecase(repository),
      ResubmitEventRequestUsecase(repository),
    );
    final graduation = EventGraduationController();
    final classes = ClassStub();
    const replacement = ClassEntity(
      classId: 'new-class',
      locationId: 'location',
      unitName: 'Nova turma',
      schedule: [],
      professor: ClassProfessorEntity(
        professorId: 'teacher',
        professorNickname: 'Professor',
      ),
      locationAddress: 'Curitiba',
    );
    classes.lecturedClasses = [replacement];
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<EventFormController>.value(value: form),
          ChangeNotifierProvider<EventProductsController>(
            create: (_) => EventProductsController(),
          ),
          ChangeNotifierProvider<EventGraduationController>.value(
            value: graduation,
          ),
          ChangeNotifierProvider<EventFormPhasesController>(
            create: (_) => EventFormPhasesController(),
          ),
          ChangeNotifierProvider<ProfileController>(
            create: (_) => ProfileStub(),
          ),
          ChangeNotifierProvider<ClassController>.value(value: classes),
          ChangeNotifierProvider<CreateLocationController>(
            create: (_) => LocationStub(),
          ),
        ],
        child: MaterialApp(
          home: EventFormPage(
            eventToEdit: eventFixture().copyWith(
              eventType: EventType.GRADUATION,
              selectedClassId: 'missing',
              selectedMembersId: {'student'},
              clearEventImage: true,
            ),
            requestId: 'request-1',
            requestStatus: GenericRequestStatus.changesRequested,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(graduation.selectedClass, isNull);
    graduation.selectClass(replacement);
    graduation.toggleMemberSelection('student');
    await tester.pump();
    tester
        .widget<EventFormNavigationBarWidget>(
          find.byType(EventFormNavigationBarWidget),
        )
        .onFinish();
    await tester.pumpAndSettle();
    expect(repository.submitted?.selectedClassId, 'new-class');
    expect(repository.submitted?.selectedMembersId, {'student'});
    await tester.pumpWidget(const SizedBox());
    form.dispose();
    graduation.dispose();
    classes.dispose();
  });

  testWidgets(
    'correction reason, restored fields, failed save and immediate list refresh',
    (tester) async {
      final repository = ListRepository()
        ..persisted = eventFixture().copyWith(clearEventImage: true);
      final form = EventFormController(
        CreateEventRequestUsecase(repository),
        ResubmitEventRequestUsecase(repository),
      );
      final phases = EventFormPhasesController();
      final products = EventProductsController();
      final graduation = EventGraduationController();
      final list = CreatedEventsController(
        GetUserEventsUsecase(repository),
        GetEventByIdUsecase(repository),
      );
      final router = GoRouter(
        initialLocation: '/events/created_events',
        routes: [EventRoutes.route],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<EventFormController>.value(value: form),
            ChangeNotifierProvider<EventProductsController>.value(
              value: products,
            ),
            ChangeNotifierProvider<EventGraduationController>.value(
              value: graduation,
            ),
            ChangeNotifierProvider<EventFormPhasesController>.value(
              value: phases,
            ),
            ChangeNotifierProvider<CreatedEventsController>.value(value: list),
            ChangeNotifierProvider<ProfileController>(
              create: (_) => ProfileStub(),
            ),
            ChangeNotifierProvider<ClassController>(create: (_) => ClassStub()),
            ChangeNotifierProvider<CreateLocationController>(
              create: (_) => LocationStub(),
            ),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();
      expect(repository.listReads, 1);
      await tester.tap(find.text('Editar evento'));
      await tester.pumpAndSettle();
      expect(
        find.text('Correções solicitadas: Corrigir o local'),
        findsOneWidget,
      );
      expect(phases.currentPhase, EventPhases.firstPhase);
      expect(products.products.single.price, 20);
      expect(form.eventValue.text, '100.00');
      form.eventName.text = 'Nome corrigido';
      phases.nextFormPhase();
      phases.nextFormPhase();
      await tester.pumpAndSettle();
      repository.result = const Left(NetworkFailure('offline'));
      await tester.tap(find.text('Salvar alterações'));
      await tester.pumpAndSettle();
      expect(form.eventName.text, 'Nome corrigido');
      expect(find.byType(EventFormPage), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      repository.result = const Right(null);
      await tester.tap(find.text('Salvar alterações'));
      await tester.pumpAndSettle();
      expect(repository.listReads, 2);
      expect(find.text('Nome corrigido'), findsOneWidget);
      expect(find.text('Atualizado'), findsOneWidget);
      expect(find.text('Editar evento'), findsNothing);
      router.push('/events/create');
      await tester.pumpAndSettle();
      expect(form.eventName.text, isEmpty);
      expect(form.isEditing, false);
      expect(products.products, isEmpty);
      expect(graduation.selectedMemberIds, isEmpty);
      expect(phases.currentPhase, EventPhases.firstPhase);
      await tester.pumpWidget(const SizedBox());
      form.dispose();
      phases.dispose();
      products.dispose();
      graduation.dispose();
      list.dispose();
    },
  );

  testWidgets('existing image is restored in form and review', (tester) async {
    final repository = RepositoryStub();
    final form = EventFormController(
      CreateEventRequestUsecase(repository),
      ResubmitEventRequestUsecase(repository),
    );
    final phases = EventFormPhasesController();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<EventFormController>.value(value: form),
          ChangeNotifierProvider<EventProductsController>(
            create: (_) => EventProductsController(),
          ),
          ChangeNotifierProvider<EventGraduationController>(
            create: (_) => EventGraduationController(),
          ),
          ChangeNotifierProvider<EventFormPhasesController>.value(
            value: phases,
          ),
          ChangeNotifierProvider<ProfileController>(
            create: (_) => ProfileStub(),
          ),
          ChangeNotifierProvider<ClassController>(create: (_) => ClassStub()),
          ChangeNotifierProvider<CreateLocationController>(
            create: (_) => LocationStub(),
          ),
        ],
        child: MaterialApp(
          home: EventFormPage(
            eventToEdit: eventFixture(),
            requestId: 'request-1',
            requestStatus: GenericRequestStatus.requested,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ExistingEventImageWidget), findsOneWidget);
    phases.nextFormPhase();
    phases.nextFormPhase();
    await tester.pumpAndSettle();
    expect(find.byType(ExistingEventImageWidget), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    form.dispose();
    phases.dispose();
  });
}
