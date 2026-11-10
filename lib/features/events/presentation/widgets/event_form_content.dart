
import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/models/event_phases.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_phase_progress_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_first_phase_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_second_phase_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_graduation_phase_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_revision_phase_widget.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';

class EventFormContent extends StatelessWidget {
  const EventFormContent({
    super.key,
    required this.phase,
    required this.eventType,
    this.requestStatus,
    this.changeReason,
  });

  final EventPhases phase;
  final EventType eventType;
  final GenericRequestStatus? requestStatus;
  final String? changeReason;

  @override
  Widget build(BuildContext context) {
    final isGraduation = phase == EventPhases.thirdPhase &&
        eventType == EventType.GRADUATION;
    final isRevision = phase == EventPhases.fourthPhase ||
        (phase == EventPhases.thirdPhase && eventType == EventType.COMPETITION);
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: StandardScaffoldBodyWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (requestStatus == GenericRequestStatus.changesRequested &&
                  changeReason?.trim().isNotEmpty == true)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Correções solicitadas: $changeReason'),
                  ),
                ),
              const EventPhaseProgressWidget(),
              const SizedBox(height: 24),
              if (phase == EventPhases.firstPhase) const EventFormFirstPhaseWidget(),
              if (phase == EventPhases.secondPhase) const EventFormSecondPhaseWidget(),
              if (isGraduation) const EventFormGraduationPhaseWidget(),
              if (isRevision) EventFormRevisionPhaseWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
