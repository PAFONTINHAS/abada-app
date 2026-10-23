import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/utils/generator.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/standard_event_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/validators/create_event_request_usecase_validator.dart';

class CreateEventRequestUsecase extends StandardEventUsecase{

  CreateEventRequestUsecase(super.eventRepository);


  Future<Either<Failure, EventRequestEntity>> call(EventEntity eventEntity, File? eventImage) async{

    EventEntity updatedEvent = eventEntity;

    if(eventImage != null){

      final String fileName = Generator.generateImageFileName(eventEntity.eventCreatorId);

      final uploadImageEvent = await eventRepository.uploadEventImage(eventImage, fileName);

      if (uploadImageEvent.isLeft()) {
        return uploadImageEvent.fold(
          (failure) => Left<Failure, EventRequestEntity>(failure),
          (_) => throw StateError('Expected an image upload failure.'),
        );
      }

      uploadImageEvent.fold((_){}, (imagePath){

        updatedEvent = eventEntity.copyWith(eventImagePath: imagePath);
      });
    }

    String? validationMessage = CreateEventRequestUsecaseValidator.validate(updatedEvent);

    if(validationMessage != null) return Left(ValidationFailure(validationMessage));

    final createEvent = await eventRepository.createEvent(updatedEvent);

    return createEvent.fold((failure) => Left(failure), (createdEvent) async{

      EventRequestEntity requestEntity = EventRequestEntity(
        requestId: '',
        requestedAt: DateTime.now(),
        eventId: createdEvent.eventId,
        eventName: eventEntity.eventName,
        initDate: eventEntity.eventInitDate,
        endingDate: eventEntity.eventEndingDate,
        requesterId: createdEvent.eventCreatorId,
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