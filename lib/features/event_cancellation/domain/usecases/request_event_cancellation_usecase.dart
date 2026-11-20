import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/utils/mask_formatter.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/domain/repository/event_cancellation_repository.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/domain/entities/event_cancellation_request_entity.dart';

class RequestEventCancellationUseCase {
  const RequestEventCancellationUseCase(this.repository);

  final EventCancellationRepository repository;

  Future<Either<Failure, EventCancellationRequestEntity>> call({
    required EventEntity event,
    required String requesterId,
    required String reason,
    required String details,
  }) async {

    final checkIfRequestAlreadyExists = await repository.checkIfRequestAlreadyExists(event.eventId);

    return checkIfRequestAlreadyExists.fold((failure) => Left(failure), (alreadyExists) async{

      if(alreadyExists) return Left(ValidationFailure("Já existe uma solicitação para esse evento"));

      final eventValue = MaskFormatter.convertMoneyStringToDouble(event.eventValue);
        
      final request = EventCancellationRequestEntity(
        id: '',
        eventId: event.eventId,
        eventTitle: event.eventName,
        requesterId: requesterId,
        creatorId: event.eventCreatorId,
        reason: reason,
        details: details,
        requestedAt: DateTime.now(),
        refundRequired: eventValue > 0,
      );

      return await repository.requestCancellation(request);
    });
  }
}
