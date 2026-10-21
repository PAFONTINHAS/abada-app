import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/utils/mask_formatter.dart';
import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_products_item.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_products_controller.dart';

class EventFormRevisionPhaseWidget extends StatelessWidget {
  const EventFormRevisionPhaseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final formController = context.read<EventFormController>();
    final productsController = context.read<EventProductsController>();
    final List<EventProductItem> products = productsController.products;

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

    final String initDateStr = DateController.formatDDMMYYYYHM(formController.eventInitDate);
    final String endDateStr = DateController.formatDDMMYYYYHM(formController.eventEndingDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Resumo Financeiro Destacado
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ColorConstants.indigoLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ColorConstants.indigoColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: ColorConstants.indigoColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.payments_outlined,
                  color: ColorConstants.whiteColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Valor Total Estimado",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.indigoDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "R\$ $totalEventStringValue",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.indigoColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Inclui inscrição e produtos obrigatórios",
                      style: TextStyle(
                        fontSize: 11,
                        color: ColorConstants.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 2. Informações Gerais do Evento
        _buildSectionCard(
          title: "Informações do Evento",
          icon: Icons.article_outlined,
          children: [
            _buildInfoRow("Nome do Evento", formController.eventName.text),
            _buildInfoRow(
              "Descrição",
              formController.eventDescription.text.isEmpty
                  ? "Sem descrição informada"
                  : formController.eventDescription.text,
            ),
            _buildInfoRow(
              "Tipo de Evento",
              EventTypeExtension.convertToUIText(formController.eventType),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 3. Data e Localização
        _buildSectionCard(
          title: "Data e Local",
          icon: Icons.location_on_outlined,
          children: [
            _buildInfoRow("Localização", formController.eventLocation.text),
            _buildInfoRow("Período", "$initDateStr até $endDateStr"),
          ],
        ),

        // 4. Seção de Graduação (se aplicável)
        if (formController.eventType.isGraduationEvent) ...[
          const SizedBox(height: 16),
          _buildSectionCard(
            title: "Dados da Graduação",
            icon: Icons.workspace_premium_outlined,
            children: [
              _buildInfoRow(
                "Turma Selecionada",
                formController.selectedClass?.unitName ?? "Não informada",
              ),
              _buildInfoRow(
                "Alunos Subindo de Corda",
                "${formController.selectedMemberIds.length} aluno(s)",
              ),
            ],
          ),
        ],

        const SizedBox(height: 16),

        // 5. Produtos Adicionais
        _buildSectionCard(
          title: "Investimento & Produtos",
          icon: Icons.shopping_bag_outlined,
          children: [
            _buildInfoRow("Valor da Inscrição", eventValue),
            const Divider(height: 20, color: ColorConstants.borderColor),
            const Text(
              "Produtos Cadastrados",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: ColorConstants.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            if (products.isEmpty)
              const Text(
                "Nenhum produto adicional vinculado.",
                style: TextStyle(
                  fontSize: 13,
                  color: ColorConstants.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ColorConstants.backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ColorConstants.borderColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.product,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: ColorConstants.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                product.mandatory
                                    ? "Obrigatório"
                                    : "Opcional",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: product.mandatory
                                      ? ColorConstants.indigoColor
                                      : ColorConstants.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "R\$ ${product.price.toStringAsFixed(2).replaceAll('.', ',')}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: ColorConstants.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),

        // 6. Imagem de Capa do Evento
        if (formController.eventImage != null) ...[
          const SizedBox(height: 16),
          _buildSectionCard(
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: ColorConstants.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: ColorConstants.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConstants.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorConstants.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: ColorConstants.indigoColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.textPrimary,
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: ColorConstants.borderColor),
          ...children,
        ],
      ),
    );
  }
}