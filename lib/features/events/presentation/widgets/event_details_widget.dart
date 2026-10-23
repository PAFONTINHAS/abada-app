import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/section_detail_card_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/revision_phase_info_row_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/revision_phase_financial_summary_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/revision_phase_aditional_products_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/revision_phase_general_event_info_widget.dart';

class EventDetailsWidget extends StatelessWidget {
  const EventDetailsWidget({
    super.key,
    required this.eventEntity,
    required this.eventValue,
    required this.initDate,
    required this.endingDate,
  });

  final EventEntity eventEntity;
  final String eventValue;
  final String initDate;
  final String endingDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Resumo Financeiro Destacado
        RevisionPhaseFinancialSummaryWidget(
          totalEventValue: eventEntity.eventValue,
        ),

        const SizedBox(height: 16),

        // 2. Informações Gerais do Evento
        RevisionPhaseGeneralEventInfoWidget(
          eventName: eventEntity.eventName,
          eventDescription:
              eventEntity.eventDescription != null &&
                  eventEntity.eventDescription!.isNotEmpty
              ? eventEntity.eventDescription!
              : "Sem descrição informada",
          eventType: EventTypeExtension.convertToUIText(eventEntity.eventType),
          eventCreatorNickname: eventEntity.eventCreatorNickname,
        ),

        const SizedBox(height: 16),

        // 3. Data e Localização
        SectionDetailCardWidget(
          title: "Data e Local",
          icon: Icons.location_on_outlined,
          children: [
            RevisionPhaseInfoRowWidget(
              label: "Localização",
              value: eventEntity.eventLocation,
            ),
            RevisionPhaseInfoRowWidget(
              label: "Período",
              value: "$initDate até $endingDate",
            ),
          ],
        ),

        // 4. Seção de Graduação (se aplicável)
        if (eventEntity.eventType.isGraduationEvent) ...[
          const SizedBox(height: 16),
          SectionDetailCardWidget(
            title: "Dados da Graduação",
            icon: Icons.workspace_premium_outlined,
            children: [
              RevisionPhaseInfoRowWidget(
                label: "Turma Selecionada",
                value: eventEntity.selectedClassId ?? "Não informada",
              ),
              RevisionPhaseInfoRowWidget(
                label: "Alunos Subindo de Corda",
                value: "${eventEntity.selectedMembersId?.length ?? 0} aluno(s)",
              ),
            ],
          ),
        ],

        const SizedBox(height: 16),

        // 5. Produtos Adicionais
        RevisionPhaseAditionalProductsWidget(
          eventValue: eventValue,
          products: eventEntity.products,
        ),

        // 6. Imagem de Capa do Evento
        if (eventEntity.eventImagePath != null) ...[
          const SizedBox(height: 16),
          SectionDetailCardWidget(
            title: "Imagem de Capa",
            icon: Icons.image_outlined,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: eventEntity.eventImagePath!,
                  progressIndicatorBuilder: (context, url, progress) =>
                      const CircularProgressIndicator(),
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
