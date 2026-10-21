import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/shared/buttons/custom_text_button.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/models/event_phases.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_phase_progress_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_first_phase_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_second_phase_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_revision_phase_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_phases_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_graduation_phase_widget.dart';

class EventFormPage extends StatelessWidget {
  const EventFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final eventFormPhasesController = context.read<EventFormPhasesController>();
    final formController = context.read<EventFormController>();

    return Scaffold(
      appBar: AppBar(title: Text("Criar evento")),
      body: StandardScaffoldBodyWidget(
        child: Selector<EventFormPhasesController, EventPhases>(
          selector: (_, controller) => controller.currentPhase,
          builder: (context, currentPhase, child) {


            final bool isGraduationEvent = 
              currentPhase == EventPhases.thirdPhase && 
              formController.eventType == EventType.GRADUATION;

            final bool isEventRevisionPhase = 
              currentPhase == EventPhases.fourthPhase || 
              currentPhase == EventPhases.thirdPhase && 
              formController.eventType == EventType.COMPETITION;

            String proceedButtonText = isEventRevisionPhase ? "Realizar Solicitação" : "Prosseguir";

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                EventPhaseProgressWidget(),

                if(currentPhase == EventPhases.firstPhase) const EventFormFirstPhaseWidget(),

                if(currentPhase == EventPhases.secondPhase) const EventFormSecondPhaseWidget(),

                if(isGraduationEvent) const EventFormGraduationPhaseWidget(),

                if(isEventRevisionPhase) EventFormRevisionPhaseWidget(),
               
                CustomTextButton(
                  text: proceedButtonText,
                  onPressed: () {

                    final bool isFirstPhaseComplete =
                        formController.isFirstPhaseComplete &&
                        currentPhase == EventPhases.firstPhase;

                    final bool isSecondPhaseComplete =
                        formController.isSecondPhaseComplete &&
                        currentPhase == EventPhases.secondPhase;

                    final bool isGraduationPhaseComplete =
                        formController.isGraduationPhaseComplete && isGraduationEvent;
                    
                    if(isFirstPhaseComplete) return eventFormPhasesController.nextFormPhase();

                    if(isSecondPhaseComplete) return eventFormPhasesController.nextFormPhase();

                    if(isGraduationPhaseComplete) return eventFormPhasesController.nextFormPhase();

                  }
                ),

                Selector<EventFormController, bool>(
                  selector: (_, controller) => controller.isFirstPhaseComplete,
                  builder: (context, isFirstPhaseComplete, child) {

                    if (!isFirstPhaseComplete || currentPhase == EventPhases.firstPhase){ 
                      return SizedBox.shrink();
                    }

                    return CustomTextButton(
                      text: "Voltar",
                      onPressed: () =>
                          eventFormPhasesController.previousFormPhase(),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

