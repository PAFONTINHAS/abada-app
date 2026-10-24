import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_products_item.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_products_controller.dart';

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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Selector<EventFormProductsController, bool>(
              selector: (_, controller) => controller.optionalProduct,
              builder: (context, optionalProduct, child) {
                return Row(
                  children: [
                    Switch.adaptive(
                      value: controller.optionalProduct,
                      activeColor: ColorConstants.indigoColor,
                      onChanged: (value) =>
                          controller.setOptionalProduct(value),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Produto Obrigatório",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: ColorConstants.textPrimary,
                      ),
                    ),
                  ],
                );
              },
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.indigoLight,
                foregroundColor: ColorConstants.indigoColor,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => controller.addProduct(),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text(
                "Adicionar",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),

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

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ColorConstants.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ColorConstants.borderColor),
                  ),
                  child: Row(
                    children: [
                      // Ícone/Avatar do Produto
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: ColorConstants.indigoLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.inventory_2_outlined,
                          size: 20,
                          color: ColorConstants.indigoColor,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Informações do Produto
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.product,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: ColorConstants.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  "R\$ ${product.price.toStringAsFixed(2).replaceAll('.', ',')}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: ColorConstants.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _buildBadge(
                                  isMandatory: product.mandatory,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Botão Remover
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                        onPressed: () => controller.removeProduct(index),
                        tooltip: "Remover produto",
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  // Tag/Badge customizada de obrigatoriedade
  Widget _buildBadge({required bool isMandatory}) {
    final Color color = isMandatory
        ? ColorConstants.indigoColor
        : ColorConstants.textSecondary;

    final Color bgColor = isMandatory
        ? ColorConstants.indigoLight
        : Colors.black.withOpacity(0.05);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isMandatory ? "Obrigatório" : "Opcional",
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}