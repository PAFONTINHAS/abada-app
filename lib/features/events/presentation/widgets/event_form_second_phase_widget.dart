import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
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
      locale: 'pt_BR', // Defina o local (ex: pt_BR para Real)
      symbol: 'R\$ ',    // Símbolo da moeda
      decimalDigits: 2,
    );

    final String? initialDropdownValue =
        formController.eventType == EventType.UNKNOWN
        ? null
        : EventTypeExtension.convertToUIText(formController.eventType); 


    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        
        Text("Tipo de evento"),
        DropdownFlutter(
          hintText: "Selecione o tipo de evento",
          // initialItem: EventTypeExtensdfdfion.convertToUIText(EventType.COMPETITION),
          items: [
            EventTypeExtension.convertToUIText(EventType.COMPETITION),
            EventTypeExtension.convertToUIText(EventType.GRADUATION),
          ],
          initialItem: initialDropdownValue ,
          onChanged: (eventType) {
            if (eventType == null) return;

            formController.setEventType(
              EventTypeExtension.getFromString(eventType),
            );
          },
        ),

        CustomTextInput(
          label: "Valor do Evento (opcional)",
          keyboardType: TextInputType.numberWithOptions(),
          hintText: "R\$ 0,00",
          mask: moneyMaskFormatter,
          hasMask: true,
          controller: formController.eventValue,
        ),

        const EventProductsSectionWidget()

      ],
    );
  }
}
