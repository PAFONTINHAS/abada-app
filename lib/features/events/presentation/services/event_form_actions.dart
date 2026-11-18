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
    final form = context.read<EventFormController>();
    form.reset();
    context.read<EventRequestSubmissionController>().reset();
    context.read<EventFormProductsController>().reset();
    context.read<EventFormGraduationController>().reset();
    context.read<EventFormPhasesController>().reset();

    if (event == null && requestId == null) {
      form.finishInitialization();
      return;
    }
    if (event == null ||
        requestId == null ||
        !EventRequestPolicy.canEdit(
          requestStatus ?? GenericRequestStatus.unknow,
        )) {
      form.finishInitialization(
        error: 'Dados insuficientes para editar o evento.',
      );
      return;
    }
    try {
      form.loadEventForEditing(event: event, requestId: requestId);
      context.read<EventFormProductsController>().loadProducts(event.products);
      final classes = context.read<ClassController>().lecturedClasses;
      final selectedClass = classes.where(
        (item) => item.classId == event.selectedClassId,
      );
      context.read<EventFormGraduationController>().loadGraduationSelection(
        selectedClass: selectedClass.isEmpty ? null : selectedClass.first,
        selectedMemberIds: event.selectedMembersId,
      );
      form.finishInitialization();
    } catch (error) {
      form.finishInitialization(
        error: 'Não foi possível carregar o evento: $error',
      );
    }
  }

  static void proceed(BuildContext context, EventPhases phase) {
    final form = context.read<EventFormController>();
    if (form.isSubmitting) return;
    final graduation = context.read<EventFormGraduationController>();
    final isGraduation =
        phase == EventPhases.thirdPhase &&
        form.eventType == EventType.GRADUATION;
    final valid =
        (phase == EventPhases.firstPhase && form.isFirstPhaseComplete) ||
        (phase == EventPhases.secondPhase && form.isSecondPhaseComplete) ||
        (isGraduation && graduation.isGraduationPhaseComplete);
    if (phase == EventPhases.fourthPhase ||
        (phase == EventPhases.thirdPhase &&
            form.eventType == EventType.COMPETITION)) {
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

  static Future<void> finish(
    BuildContext context, {
    required bool isEditing,
  }) async {
    final classController = context.read<ClassController>();
    final profileController = context.read<ProfileController>();
    final eventFormController = context.read<EventFormController>();
    final locationController = context.read<CreateLocationController>();
    final productsController = context.read<EventFormProductsController>();
    final eventRequestubmissionController = context.read<EventRequestSubmissionController>();

    if (eventFormController.isSubmitting || eventRequestubmissionController.isLoading) return;

    final graduation = context.read<EventFormGraduationController>();

    final isGraduatingUnavailable = isEditing &&   eventFormController.eventType == EventType.GRADUATION &&
        !classController.lecturedClasses.any(
          (item) => item.classId == graduation.selectedClass?.classId,
        );

    if (isGraduatingUnavailable) {
      AppMessageHandler.showWarning(
        context,
        'A turma original não foi carregada. Aguarde ou verifique a turma antes de salvar.',
      );
      return;
    }

    eventFormController.setSubmitting(true);
    
    try {
      PlaceSuggestion? place = locationController.selectedSuggestion ?? eventFormController.savedLocation;

      if (place == null) {
        LoggingService.displayError(
          "Erro ao finalizar. PlaceSugestion está nulo",
        );
        return;
      }

      LoggingService.displayInfo("Atualizando evento: ${eventFormController.requestId}");

      final user = profileController.userProfile;

      final event = eventFormController.buildEventEntity(
        products: productsController.products,
        userId: user.uid,
        userNickname: user.nickname,
        selectedMemberIds: graduation.selectedMemberIds,
        selectedClass: graduation.selectedClass,
        place: place
      );

      if (event == null) return;

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
    } catch (error) {
      if (context.mounted) {
        AppMessageHandler.showError(context, 'Erro ao salvar o evento: $error');
      }
    } finally {
      eventFormController.setSubmitting(false);
    }
  }
}
