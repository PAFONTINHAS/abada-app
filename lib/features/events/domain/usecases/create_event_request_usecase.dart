import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/standard_event_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/validators/create_event_request_usecase_validator.dart';

class CreateEventRequestUsecase extends StandardEventUsecase{

  CreateEventRequestUsecase(super.eventRepository);


  Future<Either<Failure, EventRequestEntity>> call(EventEntity eventEntity) async{

    String? validationMessage = CreateEventRequestUsecaseValidator.validate(eventEntity);

    if(validationMessage != null) return Left(ValidationFailure(validationMessage));

    final createEvent = await eventRepository.createEvent(eventEntity);

    return createEvent.fold((failure) => Left(failure), (createdEvent) async{

      EventRequestEntity requestEntity = EventRequestEntity(
        requestId: '',
        eventId: createdEvent.eventId,
        requesterId: createdEvent.eventCreatorId,
        requestedAt: DateTime.now(),
        requesterNickname: eventEntity.eventCreatorNickname,
      );

      final createRequestEvent = await eventRepository.createEventRequest(requestEntity);

      return createRequestEvent.fold((failure){ 
        
        eventRepository.removeEvent(createdEvent.eventId);
        
        return Left(failure);

      }, (createdRequest) => Right(createdRequest));
    });





  }

}