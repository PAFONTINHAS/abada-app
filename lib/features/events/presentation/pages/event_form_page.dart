import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/core/utils/message_handler.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/models/event_phases.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_phase_progress_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_page_widgets/event_form_first_phase_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_page_widgets/event_form_second_phase_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_page_widgets/event_form_revision_phase_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_page_widgets/event_form_navigation_bar_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_phases_controller.dart';
import 'package:sistema_abada_capoeira/features/location/presentation/controllers/create_location_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_products_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_page_widgets/event_form_graduation_phase_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_graduation_controller.dart';

class EventFormPage extends StatelessWidget {
  const EventFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formController = context.read<EventFormController>();
    final profileController = context.read<ProfileController>();
    final locationController = context.read<CreateLocationController>();
    final eventProductsController = context.read<EventFormProductsController>();
    final eventFormPhasesController = context.read<EventFormPhasesController>();
    final eventGraduationController = context.read<EventFormGraduationController>();

    final user = profileController.userProfile;

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Criar Evento",
          style: TextStyle(
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
      body: Selector<EventFormPhasesController, EventPhases>(
        selector: (_, controller) => controller.currentPhase,
        builder: (context, currentPhase, child) {

          final bool isGraduationEvent =
              currentPhase == EventPhases.thirdPhase &&
              formController.eventType == EventType.GRADUATION;

          final bool isEventRevisionPhase =
              currentPhase == EventPhases.fourthPhase ||
              (currentPhase == EventPhases.thirdPhase &&
                  formController.eventType == EventType.COMPETITION);

          final String proceedButtonText =
              isEventRevisionPhase ? "Realizar Solicitação" : "Prosseguir";

          final bool showBackButton = currentPhase != EventPhases.firstPhase;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: StandardScaffoldBodyWidget(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                onBack: () => eventFormPhasesController.previousFormPhase(),
                onProceed: () {

                  final bool isFirstPhaseComplete =
                      formController.isFirstPhaseComplete &&
                      currentPhase == EventPhases.firstPhase;

                  final bool isSecondPhaseComplete =
                      formController.isSecondPhaseComplete &&
                      currentPhase == EventPhases.secondPhase;

                  final bool isGraduationPhaseComplete =
                      eventGraduationController.isGraduationPhaseComplete && isGraduationEvent;

                  if(isEventRevisionPhase) return;

                  if (isFirstPhaseComplete ||
                      isSecondPhaseComplete ||
                      isGraduationPhaseComplete) {
                    return eventFormPhasesController.nextFormPhase();
                  }


                  if(isGraduationEvent){
                    return MessageHandler.showWarning(context, "Selecione uma turma ou ao menos um aluno para prosseguir");
                  }

                  return MessageHandler.showWarning(context, "Preencha todas as informações antes de prosseguir");
                },
                onFinish: () async{

                  final selectedSuggestion = locationController.selectedSuggestion;

                  if(selectedSuggestion == null) return;

                  final createdEvent = formController.buildEventEntity(
                    userId: user.uid,
                    userNickname: user.nickname,
                    city: selectedSuggestion.city,
                    state: selectedSuggestion.state,
                    products: eventProductsController.products,
                    selectedClass: eventGraduationController.selectedClass,
                    selectedMemberIds: eventGraduationController.selectedMemberIds,
                  );

                  if(createdEvent == null) return;

                  final success = await formController.createEventRequest(createdEvent);

                  if(!context.mounted) return;

                  if(success){
                    MessageHandler.showSuccess(context, "Solicitação de evento criada com sucesso");
                    context.pop();
                    return;
                  }

                  MessageHandler.showError(context, "Erro: ${formController.errorMessage}");
                },
              ),
            ],
          );
        },
      ),
    );
  }
}