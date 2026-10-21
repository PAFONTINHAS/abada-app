import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_products_section_widget.dart';

class EventFormSecondPhaseWidget extends StatelessWidget {
  const EventFormSecondPhaseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final formController = context.read<EventFormController>();

    final moneyMaskFormatter = CurrencyTextInputFormatter.currency(
      locale: 'pt_BR',
      symbol: 'R\$ ',
      decimalDigits: 2,
    );

    final String? initialDropdownValue =
        formController.eventType == EventType.UNKNOWN
            ? null
            : EventTypeExtension.convertToUIText(formController.eventType);

    final eventTypes = [
      EventTypeExtension.convertToUIText(EventType.COMPETITION),
      EventTypeExtension.convertToUIText(EventType.GRADUATION),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cartão 1: Definição do Tipo e Valor
        _buildSectionCard(
          title: "Tipo e Investimento",
          icon: Icons.category_outlined,
          children: [
            // Dropdown Nativo Estilizado
            DropdownButtonFormField<String>(
              value: initialDropdownValue,
              hint: const Text(
                "Selecione o tipo de evento",
                style: TextStyle(
                  color: ColorConstants.textSecondary,
                  fontSize: 14,
                ),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: ColorConstants.indigoColor,
              ),
              dropdownColor: ColorConstants.surfaceColor,
              style: const TextStyle(
                color: ColorConstants.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: "Tipo de Evento",
                labelStyle: const TextStyle(
                  color: ColorConstants.textSecondary,
                  fontSize: 14,
                ),
                floatingLabelStyle: const TextStyle(
                  color: ColorConstants.indigoColor,
                  fontWeight: FontWeight.bold,
                ),
                filled: true,
                fillColor: ColorConstants.backgroundColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: ColorConstants.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: ColorConstants.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: ColorConstants.indigoColor,
                    width: 1.5,
                  ),
                ),
              ),
              items: eventTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (eventType) {
                if (eventType == null) return;
                formController.setEventType(
                  EventTypeExtension.getFromString(eventType),
                );
              },
            ),

            const SizedBox(height: 16),

            // Campo de Valor do Evento
            CustomTextInput(
              label: "Valor do Evento (opcional)",
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              hintText: "R\$ 0,00",
              mask: moneyMaskFormatter,
              hasMask: true,
              controller: formController.eventValue,
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Cartão 2: Seção de Produtos Adicionais / Camisas / Acessórios
        _buildSectionCard(
          title: "Produtos e Itens Incluídos",
          icon: Icons.shopping_bag_outlined,
          children: const [
            EventProductsSectionWidget(),
          ],
        ),
      ],
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.textPrimary,
                ),
              ),
            ],
          ),
          const Divider(height: 24, color: ColorConstants.borderColor),
          ...children,
        ],
      ),
    );
  }
}