import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/shared/inputs/dropdown_input_widget.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/section_detail_card_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_page_widgets/event_products_section_widget.dart';

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
        SectionDetailCardWidget(
          title: "Tipo e Investimento",
          icon: Icons.category_outlined,
          children: [

            DropdownInputWidget(
              inputHint: "Selecione o tipo de evento",
              initialValue: initialDropdownValue,
              items: eventTypes.map((String type) {
                return DropdownMenuItem<String>(value: type, child: Text(type));
              }).toList(),
              onSelectedItem: (eventType) {
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
              controller: formController.eventValueController,
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Cartão 2: Seção de Produtos Adicionais / Camisas / Acessórios
        SectionDetailCardWidget(
          title: "Produtos e Itens Incluídos",
          icon: Icons.shopping_bag_outlined,
          children: const [
            EventProductsSectionWidget(),
          ],
        ),
      ],
    );
  }

}