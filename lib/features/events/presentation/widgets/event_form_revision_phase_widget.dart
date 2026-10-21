import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

    double totalEventDoubleValue = MaskFormatter.convertMoneyStringToDouble(
      formController.eventValue.text,
    );

    for(final product in products){

      if(product.mandatory){

        totalEventDoubleValue += product.price;
      }
    }

    String totalEventStringValue = MaskFormatter.convertMoneyDoubleToString(
      totalEventDoubleValue,
    );

    final String eventValue = formController.eventValue.text.isEmpty
        ? "GRATUITO"
        : formController.eventValue.text;

    return Column(
      children: [

        Text("Nome do evento: ${formController.eventName.text}"),
        Text("Descrição do evento: ${formController.eventDescription.text}"),
        Text("Local do evento: ${formController.eventLocation.text}"),

        Text("Tipo de Evento: ${EventTypeExtension.convertToUIText(formController.eventType)}"),
        Text(
          "Data: ${DateController.formatDDMMYYYYHM(formController.eventInitDate)} " 
          "até ${DateController.formatDDMMYYYYHM(formController.eventEndingDate)}",
        ),

        if(formController.eventImage != null)
          SizedBox(
            height: 200,
            width: 200,
            child: Image.file(formController.eventImage!),
          ),

        Text("Valor do evento: $eventValue"),

        Text("Produtos: "),

        if(productsController.products.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  dense: true,
                  title: Text(
                    product.product,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    "R\$ ${product.price.toStringAsFixed(2).replaceAll('.', ',')}"
                    "\n ${product.mandatory ? "Produto Obrigatório" : "Produto Opcional"}",
                  ),
                ),
              );
            },
          ),
        
        Text("Valor total do evento (produtos obrigatórios somados): R\$ $totalEventStringValue"),


        if(formController.eventType.isGraduationEvent) ... [

          Text("Turma selecionada para a graduação: ${formController.selectedClass?.unitName}"),

          Text("Quantidade de alunos subindo de corda: ${formController.selectedMemberIds.length}")
        ]

      ],
    );
  }
}




