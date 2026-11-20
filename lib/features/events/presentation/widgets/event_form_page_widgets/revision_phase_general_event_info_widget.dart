import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_page_widgets/revision_phase_info_row_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/section_detail_card_widget.dart';

class RevisionPhaseGeneralEventInfoWidget extends StatelessWidget {
  const RevisionPhaseGeneralEventInfoWidget({
    super.key,
    required this.eventName,
    required this.eventDescription,
    required this.eventType,
    required this.eventCreatorNickname
  });

  final String eventName;
  final String eventDescription;
  final String eventType;
  final String eventCreatorNickname;

  @override
  Widget build(BuildContext context) {
    return SectionDetailCardWidget(
      title: "Informações do Evento",
      icon: Icons.article_outlined,
      children: [
        RevisionPhaseInfoRowWidget(label: "Nome do Evento", value: eventName),
        RevisionPhaseInfoRowWidget(label: "Descrição", value: eventDescription),
        RevisionPhaseInfoRowWidget(label: "Tipo de Evento", value: eventType),
        RevisionPhaseInfoRowWidget(label: "Organizador:", value: eventCreatorNickname),
      ],
    );
  }
}
