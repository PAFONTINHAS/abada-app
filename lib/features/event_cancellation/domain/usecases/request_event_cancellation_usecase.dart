import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/event/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/domain/entities/event_cancellation_request_entity.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/domain/repository/event_cancellation_repository.dart';

class RequestEventCancellationUseCase {
  const RequestEventCancellationUseCase(this.repository);

  final EventCancellationRepository repository;

  Future<Either<Failure, EventCancellationRequestEntity>> call({
    required EventEntity event,
    required String requesterId,
    required String reason,
    required String details,
  }) {
    if (event.cancellationRequested) {
      return Future.value(
        const Left(
          ValidationFailure('Já existe uma solicitação para este evento.'),
        ),
      );
    }

    final request = EventCancellationRequestEntity(
      id: '',
      eventId: event.id,
      eventTitle: event.title,
      requesterId: requesterId,
      creatorId: event.creatorId,
      reason: reason,
      details: details,
      requestedAt: DateTime.now(),
      refundRequired: event.isPaid,
    );
    return repository.requestCancellation(request);
  }
}
