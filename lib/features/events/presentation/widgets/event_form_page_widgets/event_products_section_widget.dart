import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_products_item.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_products_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_page_widgets/event_product_details_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_page_widgets/event_mandatory_switch_widget.dart';

class EventProductsSectionWidget extends StatefulWidget {
  const EventProductsSectionWidget({super.key});

  @override
  State<EventProductsSectionWidget> createState() =>
      _EventProductsSectionWidgetState();
}

class _EventProductsSectionWidgetState
    extends State<EventProductsSectionWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = context.read<EventFormProductsController>();

    final CurrencyTextInputFormatter moneyMaskFormatter =
        CurrencyTextInputFormatter.currency(
          locale: 'pt_BR',
          symbol: 'R\$ ',
          decimalDigits: 2,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Campo Nome do Produto
        CustomTextInput(
          label: "Nome do Produto",
          controller: controller.nameController,
          hintText: "Ex: Camiseta, Botton, Caneca",
        ),

        const SizedBox(height: 16),

        // Campo Valor do Produto
        CustomTextInput(
          label: "Valor do Produto (opcional)",
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          hintText: "R\$ 0,00",
          mask: moneyMaskFormatter,
          hasMask: true,
          controller: controller.priceController,
        ),

        const SizedBox(height: 12),

        // Switch de Obrigatoriedade + Botão Adicionar
        EventMandatorySwitchWidget(controller: controller),

        const Divider(height: 32, color: ColorConstants.borderColor),

        // Lista de produtos adicionados
        Selector<EventFormProductsController, List<EventProductItem>>(
          selector: (_, controller) => controller.products,
          builder: (context, products, child) {
            if (products.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                decoration: BoxDecoration(
                  color: ColorConstants.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ColorConstants.borderColor,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: const [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 32,
                      color: ColorConstants.textSecondary,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Nenhum produto adicionado até o momento.",
                      style: TextStyle(
                        color: ColorConstants.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final product = products[index];

                return EventProductDetailsWidget(
                  product: product,
                  index: index,
                  controller: controller,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
