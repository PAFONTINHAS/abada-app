import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/domain/entities/event_cancellation_request_entity.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/domain/repository/event_cancellation_repository.dart';

class GetPendingEventCancellationRequestsUseCase {
  const GetPendingEventCancellationRequestsUseCase(this.repository);

  final EventCancellationRepository repository;

  Future<Either<Failure, List<EventCancellationRequestEntity>>> call() {
    return repository.getPendingRequests();
  }
}
