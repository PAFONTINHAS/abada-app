
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/core/utils/message_handler.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_controller.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_policy.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_phases_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_graduation_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_products_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_request_submission_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/models/event_phases.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';

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
    context.read<EventProductsController>().reset();
    context.read<EventGraduationController>().reset();
    context.read<EventFormPhasesController>().reset();

    if (event == null && requestId == null) {
      form.finishInitialization();
      return;
    }
    if (event == null || requestId == null ||
        !EventRequestPolicy.canEdit(requestStatus ?? GenericRequestStatus.unknow)) {
      form.finishInitialization(error: 'Dados insuficientes para editar o evento.');
      return;
    }
    try {
      form.loadEventForEditing(event: event, requestId: requestId);
      context.read<EventProductsController>().loadProducts(event.products);
      final classes = context.read<ClassController>().lecturedClasses;
      final selectedClass = classes.where(
        (item) => item.classId == event.selectedClassId,
      );
      context.read<EventGraduationController>().loadGraduationSelection(
        selectedClass: selectedClass.isEmpty ? null : selectedClass.first,
        selectedMemberIds: event.selectedMembersId,
      );
      form.finishInitialization();
    } catch (error) {
      form.finishInitialization(error: 'Não foi possível carregar o evento: $error');
    }
  }

  static void proceed(BuildContext context, EventPhases phase) {
    final form = context.read<EventFormController>();
    if (form.isSubmitting) return;
    final graduation = context.read<EventGraduationController>();
    final isGraduation = phase == EventPhases.thirdPhase &&
        form.eventType == EventType.GRADUATION;
    final valid = (phase == EventPhases.firstPhase && form.isFirstPhaseComplete) ||
        (phase == EventPhases.secondPhase && form.isSecondPhaseComplete) ||
        (isGraduation && graduation.isGraduationPhaseComplete);
    if (phase == EventPhases.fourthPhase ||
        (phase == EventPhases.thirdPhase && form.eventType == EventType.COMPETITION)) {
      return;
    }
    if (valid) {
      context.read<EventFormPhasesController>().nextFormPhase();
    } else {
      MessageHandler.showWarning(context, isGraduation
          ? 'Selecione uma turma ou ao menos um aluno para prosseguir'
          : 'Preencha todas as informações antes de prosseguir');
    }
  }

  static Future<void> finish(BuildContext context, {required bool isEditing}) async {
    final form = context.read<EventFormController>();
    final submission = context.read<EventRequestSubmissionController>();
    if (form.isSubmitting || submission.isLoading) return;
    final graduation = context.read<EventGraduationController>();
    if (isEditing && form.eventType == EventType.GRADUATION &&
        !context.read<ClassController>().lecturedClasses.any(
          (item) => item.classId == graduation.selectedClass?.classId,
        )) {
      MessageHandler.showWarning(context,
          'A turma original não foi carregada. Aguarde ou verifique a turma antes de salvar.');
      return;
    }
    form.setSubmitting(true);
    try {
      final user = context.read<ProfileController>().userProfile;
      final event = form.buildEventEntity(
        products: context.read<EventProductsController>().products,
        userId: user.uid,
        userNickname: user.nickname,
        selectedMemberIds: graduation.selectedMemberIds,
        selectedClass: graduation.selectedClass,
      );
      if (event == null) return;
      final success = isEditing
          ? await submission.resubmitEventRequest(
              requestId: form.requestId, event: event, eventImage: form.eventImage)
          : await submission.createEventRequest(event, form.eventImage);
      if (!context.mounted) return;
      if (success) {
        MessageHandler.showSuccess(context, isEditing
            ? (submission.savedStatus == GenericRequestStatus.updated
                ? 'Evento corrigido e reenviado com sucesso'
                : 'Alterações salvas com sucesso')
            : 'Solicitação de evento criada com sucesso');
        context.pop(true);
      } else {
        MessageHandler.showError(context, 'Erro: ${submission.errorMessage}');
      }
    } catch (error) {
      if (context.mounted) {
        MessageHandler.showError(context, 'Erro ao salvar o evento: $error');
      }
    } finally {
      form.setSubmitting(false);
    }
  }
}
