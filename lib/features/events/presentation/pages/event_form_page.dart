import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_policy.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:sistema_abada_capoeira/core/utils/message_handler.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/models/event_phases.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_phase_progress_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_products_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_first_phase_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_second_phase_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_graduation_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_revision_phase_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_navigation_bar_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_phases_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_graduation_phase_widget.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_controller.dart';

class EventFormPage extends StatefulWidget {
  const EventFormPage({
    super.key,
    this.eventToEdit,
    this.requestId,
    this.requestStatus,
    this.changeReason,
  });

  final EventEntity? eventToEdit;
  final String? requestId;
  final GenericRequestStatus? requestStatus;
  final String? changeReason;

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  bool _isInitializing = true;
  bool _isSubmitting = false;
  String? _initializationError;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _initializeForm();
    });
  }

  void _initializeForm() {
    final event = widget.eventToEdit;
    final requestId = widget.requestId;

    // Start each form session without state from a previous event.
    context.read<EventFormController>().reset();
    context.read<EventProductsController>().reset();
    context.read<EventGraduationController>().reset();
    context.read<EventFormPhasesController>().reset();

    // Criação de um novo evento.
    if (event == null && requestId == null) {
      setState(() {
        _isInitializing = false;
      });
      return;
    }

    // A edição exige os dois parâmetros.
    if (event == null ||
        requestId == null ||
        !EventRequestPolicy.canEdit(
          widget.requestStatus ?? GenericRequestStatus.unknow,
        )) {
      setState(() {
        _initializationError = 'Dados insuficientes para editar o evento.';
        _isInitializing = false;
      });
      return;
    }

    try {
      final formController = context.read<EventFormController>();
      final productsController = context.read<EventProductsController>();
      final graduationController = context.read<EventGraduationController>();
      final classController = context.read<ClassController>();

      // RF22 - Carrega o evento e preserva sua solicitação.
      formController.loadEventForEditing(event: event, requestId: requestId);

      // Restaura os produtos existentes.
      productsController.loadProducts(event.products);

      // Recupera a turma vinculada ao evento.
      ClassEntity? selectedClass;

      for (final classEntity in classController.lecturedClasses) {
        if (classEntity.classId == event.selectedClassId) {
          selectedClass = classEntity;
          break;
        }
      }

      // Restaura turma e alunos selecionados.
      graduationController.loadGraduationSelection(
        selectedClass: selectedClass,
        selectedMemberIds: event.selectedMembersId,
      );

      if (!mounted) return;

      setState(() {
        _isInitializing = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _initializationError = 'Não foi possível carregar o evento: $error';
        _isInitializing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileController = context.read<ProfileController>();
    final formController = context.watch<EventFormController>();
    final eventProductsController = context.read<EventProductsController>();
    final eventFormPhasesController = context.read<EventFormPhasesController>();
    final eventGraduationController = context.read<EventGraduationController>();

    final user = profileController.userProfile;

    // Usa os parâmetros da rota para identificar a edição
    // enquanto o formulário ainda está sendo inicializado.
    final isEditing = widget.eventToEdit != null && widget.requestId != null;

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          isEditing ? "Editar Evento" : "Criar Evento",
          style: const TextStyle(
            color: ColorConstants.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: ColorConstants.surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        iconTheme: const IconThemeData(color: ColorConstants.textPrimary),
      ),
      body: _isInitializing
          ? const Center(child: CircularProgressIndicator())
          : _initializationError != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  _initializationError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            )
          : Selector<EventFormPhasesController, EventPhases>(
              selector: (_, controller) => controller.currentPhase,
              builder: (context, currentPhase, child) {
                final isGraduationEvent =
                    currentPhase == EventPhases.thirdPhase &&
                    formController.eventType == EventType.GRADUATION;

                final isEventRevisionPhase =
                    currentPhase == EventPhases.fourthPhase ||
                    (currentPhase == EventPhases.thirdPhase &&
                        formController.eventType == EventType.COMPETITION);

                final proceedButtonText = isEventRevisionPhase
                    ? (isEditing ? "Salvar alterações" : "Realizar Solicitação")
                    : "Prosseguir";

                final showBackButton = currentPhase != EventPhases.firstPhase;

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        child: StandardScaffoldBodyWidget(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (widget.requestStatus ==
                                      GenericRequestStatus.changesRequested &&
                                  widget.changeReason?.trim().isNotEmpty ==
                                      true)
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      'Correções solicitadas: ${widget.changeReason}',
                                    ),
                                  ),
                                ),
                              const EventPhaseProgressWidget(),
                              const SizedBox(height: 24),

                              if (currentPhase == EventPhases.firstPhase)
                                const EventFormFirstPhaseWidget(),

                              if (currentPhase == EventPhases.secondPhase)
                                const EventFormSecondPhaseWidget(),

                              if (isGraduationEvent)
                                const EventFormGraduationPhaseWidget(),

                              if (isEventRevisionPhase)
                                EventFormRevisionPhaseWidget(),
                            ],
                          ),
                        ),
                      ),
                    ),

                    EventFormNavigationBarWidget(
                      proceedText: proceedButtonText,
                      showBackButton: showBackButton,
                      onBack: () {
                        if (_isSubmitting) return;

                        eventFormPhasesController.previousFormPhase();
                      },
                      onProceed: () {
                        if (_isSubmitting) return;

                        final isFirstPhaseComplete =
                            formController.isFirstPhaseComplete &&
                            currentPhase == EventPhases.firstPhase;

                        final isSecondPhaseComplete =
                            formController.isSecondPhaseComplete &&
                            currentPhase == EventPhases.secondPhase;

                        final isGraduationPhaseComplete =
                            eventGraduationController
                                .isGraduationPhaseComplete &&
                            isGraduationEvent;

                        if (isEventRevisionPhase) return;

                        if (isFirstPhaseComplete ||
                            isSecondPhaseComplete ||
                            isGraduationPhaseComplete) {
                          eventFormPhasesController.nextFormPhase();
                          return;
                        }

                        if (isGraduationEvent) {
                          MessageHandler.showWarning(
                            context,
                            "Selecione uma turma ou ao menos um aluno para prosseguir",
                          );
                          return;
                        }

                        MessageHandler.showWarning(
                          context,
                          "Preencha todas as informações antes de prosseguir",
                        );
                      },
                      onFinish: () async {
                        if (_isSubmitting || formController.isLoading) {
                          return;
                        }

                        if (isEditing &&
                            formController.eventType == EventType.GRADUATION &&
                            !context
                                .read<ClassController>()
                                .lecturedClasses
                                .any(
                                  (item) =>
                                      item.classId ==
                                      eventGraduationController
                                          .selectedClass
                                          ?.classId,
                                )) {
                          MessageHandler.showWarning(
                            context,
                            "A turma original não foi carregada. Aguarde ou verifique a turma antes de salvar.",
                          );
                          return;
                        }

                        setState(() {
                          _isSubmitting = true;
                        });

                        try {
                          final event = formController.buildEventEntity(
                            products: eventProductsController.products,
                            userId: user.uid,
                            userNickname: user.nickname,
                            selectedMemberIds:
                                eventGraduationController.selectedMemberIds,
                            selectedClass:
                                eventGraduationController.selectedClass,
                          );

                          if (event == null) return;

                          final bool success;

                          if (isEditing) {
                            // RF22 - Atualiza a solicitação
                            // existente.
                            success = await formController.resubmitEventRequest(
                              event,
                            );
                          } else {
                            success = await formController.createEventRequest(
                              event,
                            );
                          }

                          if (!context.mounted) return;

                          if (success) {
                            MessageHandler.showSuccess(
                              context,
                              isEditing
                                  ? (formController.savedStatus ==
                                            GenericRequestStatus.updated
                                        ? "Evento corrigido e reenviado com sucesso"
                                        : "Alterações salvas com sucesso")
                                  : "Solicitação de evento criada com sucesso",
                            );

                            context.pop(true);
                            return;
                          }

                          MessageHandler.showError(
                            context,
                            "Erro: ${formController.errorMessage}",
                          );
                        } catch (error) {
                          if (!context.mounted) return;

                          MessageHandler.showError(
                            context,
                            "Erro ao salvar o evento: $error",
                          );
                        } finally {
                          if (mounted) {
                            setState(() {
                              _isSubmitting = false;
                            });
                          }
                        }
                      },
                    ),
                  ],
                );
              },
            ),
    );
  }
}
