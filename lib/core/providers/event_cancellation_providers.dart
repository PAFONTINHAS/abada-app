import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/data/datasources/event_cancellation_remote_datasource.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/data/datasources/event_cancellation_remote_datasource_impl.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/data/repository/event_cancellation_repository_impl.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/domain/repository/event_cancellation_repository.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/domain/usecases/request_event_cancellation_usecase.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/domain/usecases/review_event_cancellation_usecase.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/domain/usecases/get_pending_event_cancellation_requests_usecase.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/presentation/controllers/event_cancellation_controller.dart';

class EventCancellationProviders {
  EventCancellationProviders._();

  static final EventCancellationRemoteDatasource datasource =
      EventCancellationRemoteDatasourceImpl();
  static final EventCancellationRepository repository =
      EventCancellationRepositoryImpl(datasource);
  static final RequestEventCancellationUseCase requestUseCase =
      RequestEventCancellationUseCase(repository);
  static final ReviewEventCancellationUseCase reviewUseCase =
      ReviewEventCancellationUseCase(repository);
  static final GetPendingEventCancellationRequestsUseCase getPendingUseCase =
      GetPendingEventCancellationRequestsUseCase(repository);

  static final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(
      create: (_) => EventCancellationController(
        requestUseCase,
        reviewUseCase,
        getPendingUseCase,
      ),
    ),
  ];
}
