import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/models/event_phases.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/phase_progress_marker_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_phases_controller.dart';

class EventPhaseProgressWidget extends StatelessWidget {
  const EventPhaseProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<EventFormPhasesController, EventPhases>(
      selector: (_, controller) => controller.currentPhase,
      builder: (context, currentPhase, child) {
        return Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          child: Selector<EventFormController, EventType>(
            selector: (_, controller) => controller.eventType,
            builder: (context, eventType, child) {

              bool isEventGraduation = eventType == EventType.GRADUATION;

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: PhaseProgressMarkerWidget(
                      phaseText: "Dados",
                      phase: EventPhases.firstPhase,
                      phaseNumber: '1',
                      phaseColor: Colors.black,
                      currentPhase: currentPhase,
                      isCompleted: currentPhase != EventPhases.firstPhase,
                    ),
                  ),

                  Expanded(
                    child: PhaseProgressMarkerWidget(
                      phase: EventPhases.secondPhase,
                      phaseText: "Valor",
                      phaseColor: Colors.black,
                      phaseNumber: "2",
                      currentPhase: currentPhase,
                      isCompleted:
                        currentPhase.phaseNumber > EventPhases.secondPhase.phaseNumber
                    ),
                  ),
                  
                  
                  if(isEventGraduation) 
                    Expanded(
                      child: PhaseProgressMarkerWidget(
                        phase: EventPhases.thirdPhase,
                        phaseText: "Graduação",
                        phaseColor: Colors.black,
                        phaseNumber: isEventGraduation ? "3" : "2",
                        currentPhase: currentPhase,
                        isCompleted:
                          currentPhase.phaseNumber > EventPhases.thirdPhase.phaseNumber
                      ),
                    ),

                  PhaseProgressMarkerWidget(
                    phase: isEventGraduation ? EventPhases.fourthPhase: EventPhases.thirdPhase ,
                    phaseText: "Revisão",
                    phaseColor: Colors.black,
                    phaseNumber: isEventGraduation ? "4" : "3",
                    currentPhase: currentPhase,
                    isLastPhase: true,
                    isCompleted: false,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
