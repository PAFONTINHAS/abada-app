import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/utils/mask_formatter.dart';
import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_products_item.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_graduation_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/section_detail_card_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_products_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/revision_phase_info_row_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/revision_phase_aditional_products_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/revision_phase_financial_summary_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/revision_phase_general_event_info_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';

class EventFormRevisionPhaseWidget extends StatelessWidget {
  const EventFormRevisionPhaseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final formController = context.read<EventFormController>();
    final profileController = context.read<ProfileController>();
    final productsController = context.read<EventFormProductsController>();
    final List<EventProductItem> products = productsController.products;
    final eventGraduationController = context.read<EventFormGraduationController>();

    final userProfile = profileController.userProfile;

    // Cálculo do valor total (Evento + Produtos Obrigatórios)
    double totalEventDoubleValue = MaskFormatter.convertMoneyStringToDouble(
      formController.eventValue.text,
    );

    for (final product in products) {
      if (product.mandatory) {
        totalEventDoubleValue += product.price;
      }
    }

    String totalEventStringValue = MaskFormatter.convertMoneyDoubleToString(
      totalEventDoubleValue,
    );

    final String eventValue = formController.eventValue.text.isEmpty
        ? "GRATUITO"
        : formController.eventValue.text;

    final String initDateStr = DateController.formatDDMMYYYYHM(
      formController.eventInitDate,
    );
    final String endDateStr = DateController.formatDDMMYYYYHM(
      formController.eventEndingDate,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Resumo Financeiro Destacado
        RevisionPhaseFinancialSummaryWidget(totalEventValue: totalEventStringValue),

        const SizedBox(height: 16),

        // 2. Informações Gerais do Evento
        RevisionPhaseGeneralEventInfoWidget(
          eventName: formController.eventName.text,
          eventDescription: formController.eventDescription.text.isEmpty
              ? "Sem descrição informada"
              : formController.eventDescription.text,
          eventType: EventTypeExtension.convertToUIText(
            formController.eventType,

          ),
          eventCreatorNickname: userProfile.nickname,
        ),

    
        const SizedBox(height: 16),

        // 3. Data e Localização
        SectionDetailCardWidget(
          title: "Data e Local",
          icon: Icons.location_on_outlined,
          children: [
            RevisionPhaseInfoRowWidget(
              label: "Localização",
              value: formController.eventLocation.text,
            ),
            RevisionPhaseInfoRowWidget(
              label: "Período",
              value: "$initDateStr até $endDateStr",
            ),
          ],
        ),

        // 4. Seção de Graduação (se aplicável)
        if (formController.eventType.isGraduationEvent) ...[
          const SizedBox(height: 16),
          SectionDetailCardWidget(
            title: "Dados da Graduação",
            icon: Icons.workspace_premium_outlined,
            children: [
              RevisionPhaseInfoRowWidget(
                label: "Turma Selecionada",
                value:
                    eventGraduationController.selectedClass?.unitName ?? "Não informada",
              ),
              RevisionPhaseInfoRowWidget(
                label: "Alunos Subindo de Corda",
                value: "${eventGraduationController.selectedMemberIds.length} aluno(s)",
              ),
            ],
          ),
        ],

        const SizedBox(height: 16),

        // 5. Produtos Adicionais
        RevisionPhaseAditionalProductsWidget(
          eventValue: eventValue,
          products: products,
        ),


        // 6. Imagem de Capa do Evento
        if (formController.eventImage != null) ...[
          const SizedBox(height: 16),
          SectionDetailCardWidget(
            title: "Imagem de Capa",
            icon: Icons.image_outlined,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  formController.eventImage!,
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
