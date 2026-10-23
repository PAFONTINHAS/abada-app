import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sistema_abada_capoeira/features/events/data/datasources/event_remote_datasource.dart';
import 'package:sistema_abada_capoeira/features/events/data/datasources/event_remote_datasource_impl.dart';
import 'package:sistema_abada_capoeira/features/events/domain/repository/event_repository.dart';
import 'package:sistema_abada_capoeira/features/events/data/repository/event_repository_impl.dart';
import 'package:sistema_abada_capoeira/features/events/data/datasources/event_requests_remote_datasource.dart';
import 'package:sistema_abada_capoeira/features/events/data/datasources/event_requests_remote_datasource_impl.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/create_event_request_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/get_event_by_id_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/get_pending_events_requests_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/get_user_events_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/created_events_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_details_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_graduation_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_products_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_phases_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_requests_controller.dart';

class EventProviders {

  EventProviders._();

  static EventRequestsRemoteDatasource eventRequestsRemoteDatasource = EventRequestsRemoteDatasourceImpl();
  static EventRemoteDatasource eventRemoteDatasource = EventRemoteDatasourceImpl();

  static EventRepository eventRepository = EventRepositoryImpl(eventRequestsRemoteDatasource, eventRemoteDatasource);

  static GetEventByIdUsecase getEventByIdUsecase = GetEventByIdUsecase(eventRepository);
  static GetUserEventsUsecase getUserEventsUsecase = GetUserEventsUsecase(eventRepository);
  static CreateEventRequestUsecase createEventRequestUsecase = CreateEventRequestUsecase(eventRepository);
  static GetPendingEventsRequestsUsecase getPendingEventsRequestsUsecase = GetPendingEventsRequestsUsecase(eventRepository);

  static final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => EventProductsController()),
    ChangeNotifierProvider(create: (_) => EventFormPhasesController()),
    ChangeNotifierProvider(create: (_) => EventGraduationController()),
    ChangeNotifierProvider(create: (_) => EventDetailsController(getEventByIdUsecase)),
    ChangeNotifierProvider(create: (_) => CreatedEventsController(getUserEventsUsecase)),
    ChangeNotifierProvider(create: (_) => EventFormController(createEventRequestUsecase)),
    ChangeNotifierProvider(create: (_) => EventRequestsController(getPendingEventsRequestsUsecase))
  ];
}