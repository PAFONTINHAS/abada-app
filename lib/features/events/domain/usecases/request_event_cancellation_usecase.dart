import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/utils/mask_formatter.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_type.dart';
import 'package:sistema_abada_capoeira/features/events/domain/repository/event_repository.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_cancelation_aditional_data_entity.dart';

class RequestEventCancellationUseCase {
  const RequestEventCancellationUseCase(this.repository);

  final EventRepository repository;

  Future<Either<Failure, EventRequestEntity>> call({
    required EventEntity event,
    required String requesterId,
    required String reason,
    required String details,
    required String requesterNickname,
  }) async {

    final checkIfRequestAlreadyExists = await repository.checkIfRequestAlreadyExists(event.eventId, requestType: EventRequestType.cancelation);

    return checkIfRequestAlreadyExists.fold((failure) => Left(failure), (alreadyExists) async{

      if(alreadyExists) return Left(ValidationFailure("Já existe uma solicitação para esse evento"));

      final eventValue = MaskFormatter.convertMoneyStringToDouble(event.eventValue);

      final eventCancelationAditionalDataEntity = EventCancelationAditionalDataEntity(
        reason: reason,
        details: details,
        refundRequired: eventValue > 0,
      );

      final request = EventRequestEntity(
        requestId: '',
        eventId: event.eventId,
        requesterId: requesterId,
        eventName: event.eventName,
        requestedAt: DateTime.now(),
        initDate: event.eventInitDate,
        endingDate: event.eventEndingDate,
        requesterNickname: requesterNickname,
        requestType: EventRequestType.cancelation,
        eventCancelationAditionalDataEntity: eventCancelationAditionalDataEntity
      );
        
      return await repository.createEventRequest(request);
    });
  }
}
