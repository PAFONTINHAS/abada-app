import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/core/utils/generator.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/standard_event_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/validators/create_event_request_usecase_validator.dart';

class ResubmitEventRequestUsecase extends StandardEventUsecase {
  ResubmitEventRequestUsecase(super.eventRepository);

  /// Valida o evento corrigido e reenvia a solicitação existente.
  Future<Either<Failure, GenericRequestStatus>> call(String requestId, EventEntity eventEntity, File? eventImage) async {

    LoggingService.displayInfo("Validando slicitação de evento");

    if (requestId.trim().isEmpty || eventEntity.eventId.trim().isEmpty) {
      return const Left(
        ValidationFailure('ID da solicitação ou do evento inválido.'),
      );
    }

    EventEntity updatedEvent = eventImage == null
        ? eventEntity.copyWith(clearEventImage: true)
        : eventEntity;
    String? uploadedImage;

    // Valida os dados antes de realizar qualquer upload.
    final validationMessage = CreateEventRequestUsecaseValidator.validate(
      updatedEvent,
    );

    if (validationMessage != null) {
      return Left(ValidationFailure(validationMessage));
    }

    // Envia uma nova imagem somente se o usuário selecionar outra.
    if (eventImage != null) {
      final fileName = Generator.uniqueEventImageName();

      final uploadResult = await eventRepository.uploadEventImage(
        eventImage,
        fileName,
      );

      if (uploadResult.isLeft()) {
        return uploadResult.fold(
          (failure) => Left<Failure, GenericRequestStatus>(failure),
          (_) => throw StateError('Expected an image upload failure.'),
        );
      }

      uploadResult.fold((_) {}, (imagePath) {
        uploadedImage = imagePath;
        updatedEvent = updatedEvent.copyWith(eventImagePath: imagePath);
      });
    }


    LoggingService.displayInfo("Reenviando solicitação de evento");


    // Atualiza o evento e a solicitação na mesma transação.
    final result = await eventRepository.resubmitEventRequest(
      requestId,
      updatedEvent,
    );
      
    final definitelyRejected = result.fold(
      (failure) => failure is ValidationFailure || failure is UnauthorizedFailure,
      (_) => false,
    );
    
    if (definitelyRejected && uploadedImage != null) {
      
      final persisted = await eventRepository.getEventById(eventEntity.eventId);

      await persisted.fold((_) async {}, (event) async {
        if (event.eventImagePath != uploadedImage) {
          await eventRepository.deleteEventImage(uploadedImage!);
        }
      });
    }

  LoggingService.displayInfo("Evento atualizado com sucesso");
    return result;
  }
}
