import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/services/location_service/place_suggestion.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/core/utils/app_message_handler.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/models/event_phases.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_policy.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_phases_controller.dart';
import 'package:sistema_abada_capoeira/features/location/presentation/controllers/create_location_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_products_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_graduation_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_request_submission_controller.dart';

class EventFormActions {
  const EventFormActions._();

  static void initialize(
    BuildContext context, {
    required EventEntity? event,
    required String? requestId,
    required GenericRequestStatus? requestStatus,
  }) {


    final classController = context.read<ClassController>();
    final eventFormController = context.read<EventFormController>();
    final eventFormPhasesController = context.read<EventFormPhasesController>();
    final eventFormProductsController = context.read<EventFormProductsController>();
    final eventFormGraduationController = context.read<EventFormGraduationController>();
    final eventRequestSubsmissionController = context.read<EventRequestSubmissionController>();

    eventFormController.reset();
    eventFormPhasesController.reset();
    eventFormProductsController.reset();
    eventFormGraduationController.reset();
    eventRequestSubsmissionController.reset();

    final isValidEvent = event != null;
    final isValidRequest = requestId != null;
    final canEditEvent = EventRequestPolicy.canEdit(requestStatus ?? GenericRequestStatus.unknow);

    if (!isValidEvent && !isValidRequest) {
      eventFormController.finishInitialization();
      return;
    }

    if (!isValidEvent || !isValidRequest || !canEditEvent) {
      eventFormController.finishInitialization(
        error: 'Dados insuficientes para editar o evento.',
      );
      return;
    }

    try {

      eventFormController.beginEditing(event: event, requestId: requestId);
      eventFormProductsController.loadProducts(event.products);

      final classes = classController.lecturedClasses;
      final selectedClass = classes.where(
        (item) => item.classId == event.selectedClassId,
      );

      eventFormGraduationController.loadGraduationSelection(
        selectedClass: selectedClass.isEmpty ? null : selectedClass.first,
        selectedMemberIds: event.selectedMembersId,
      );

      eventFormController.finishInitialization();

    } catch (error) {
      eventFormController.finishInitialization(
        error: 'Não foi possível carregar o evento: $error',
      );
    }
  }

  static void proceed(BuildContext context, EventPhases phase) {
    
    final form = context.read<EventFormController>();
    
    if (form.isSubmitting) return;
    
    final graduation = context.read<EventFormGraduationController>();
    final isGraduation = phase == EventPhases.thirdPhase && form.eventType == EventType.GRADUATION;

    final valid =
      (phase == EventPhases.firstPhase && form.isFirstPhaseComplete)   ||
      (phase == EventPhases.secondPhase && form.isSecondPhaseComplete) ||
      (isGraduation && graduation.isGraduationPhaseComplete);

    if (phase == EventPhases.fourthPhase || (phase == EventPhases.thirdPhase && form.eventType == EventType.COMPETITION)) {
      return;
    }

    if (valid) {
      context.read<EventFormPhasesController>().nextFormPhase();
    } else {
      AppMessageHandler.showWarning(
        context,
        isGraduation
            ? 'Selecione uma turma ou ao menos um aluno para prosseguir'
            : 'Preencha todas as informações antes de prosseguir',
      );
    }
  }

  static Future<void> finish(BuildContext context, {required bool isEditing}) async {

    final classController = context.read<ClassController>();
    final profileController = context.read<ProfileController>();
    final eventFormController = context.read<EventFormController>();
    final graduationController = context.read<EventFormGraduationController>();
    final locationController = context.read<CreateLocationController>();
    final productsController = context.read<EventFormProductsController>();
    final eventRequestubmissionController = context.read<EventRequestSubmissionController>();

    final user = profileController.userProfile;

    if (eventFormController.isSubmitting || eventRequestubmissionController.isLoading) return;

    final isGraduatingUnavailable = 
      isEditing && 
      eventFormController.eventType.isGraduationEvent &&
      !classController.lecturedClasses.any(
        (item) => item.classId == graduationController.selectedClass?.classId,
      );

    if (isGraduatingUnavailable) {
      AppMessageHandler.showWarning(
        context,
        'A turma original não foi carregada. Aguarde ou verifique a turma antes de salvar.',
      );
      return;
    }

    eventFormController.setSubmitting(true);
    
    PlaceSuggestion? place = locationController.selectedSuggestion ?? eventFormController.savedLocation;

    if (place == null) {
      return LoggingService.displayError("Erro ao finalizar. PlaceSugestion está nulo");
    }

    EventEntity? event;

    if(isEditing){
      event = eventFormController.buildUpdatedEventEntity(
        products: productsController.products,
        selectedMemberIds: graduationController.selectedMemberIds,
        selectedClass: graduationController.selectedClass,
        place: place
      );
    } else{

      event = eventFormController.buildEventEntity(
        products: productsController.products,
        userId: user.uid,
        userNickname: user.nickname,
        selectedMemberIds: graduationController.selectedMemberIds,
        selectedClass: graduationController.selectedClass,
        place: place
      );
    }

    if (event == null) return;

    if(isEditing){
      LoggingService.displayInfo("Atualizando o evento: ${event.eventId}. Solicitação: ${eventFormController.requestId}");
    }

    final success = isEditing
      ? await eventRequestubmissionController.resubmitEventRequest(
          event: event,
          requestId: eventFormController.requestId,
          eventImage: eventFormController.eventImage,
        )
      : await eventRequestubmissionController.createEventRequest(event, eventFormController.eventImage);

    if (!context.mounted) return;

    if (success) {
      AppMessageHandler.showSuccess(
        context,
        isEditing
            ? (eventRequestubmissionController.savedStatus == GenericRequestStatus.updated
                  ? 'Evento corrigido e reenviado com sucesso'
                  : 'Alterações salvas com sucesso')
            : 'Solicitação de evento criada com sucesso',
      );
      context.pop(true);
    } else {
      AppMessageHandler.showError(
        context,
        'Erro: ${eventRequestubmissionController.errorMessage}',
      );
    }

    eventFormController.setSubmitting(false);
  }
}
