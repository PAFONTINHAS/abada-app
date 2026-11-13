import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/domain/entities/event_cancellation_request_entity.dart';

abstract class EventCancellationRemoteDatasource {
  Future<Either<Failure, EventCancellationRequestEntity>> requestCancellation(
    EventCancellationRequestEntity request,
  );

  Future<Either<Failure, List<EventCancellationRequestEntity>>>
  getPendingRequests();

  Future<Either<Failure, EventCancellationRequestEntity>> reviewCancellation({
    required EventCancellationRequestEntity request,
    required bool approve,
    required String reviewerId,
  });
}
