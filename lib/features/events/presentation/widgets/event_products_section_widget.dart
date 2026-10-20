import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_products_item.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_products_controller.dart';

class EventProductsSectionWidget extends StatefulWidget {
  const EventProductsSectionWidget({super.key});

  @override
  State<EventProductsSectionWidget> createState() => _EventProductsSectionWidgetState();
}

class _EventProductsSectionWidgetState extends State<EventProductsSectionWidget> {

  @override
  Widget build(BuildContext context) {
    final controller = context.read<EventProductsController>();

    final CurrencyTextInputFormatter moneyMaskFormatter = CurrencyTextInputFormatter.currency(
      locale: 'pt_BR',
      symbol: 'R\$ ',
      decimalDigits: 2,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Produtos do Evento (opcional)",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Campo Nome do Produto
        CustomTextInput(
          label: "Nome do Produto",
          controller: controller.nameController,
          hintText: "Ex: Camiseta, Botton, Caneca",
        ),
        
        CustomTextInput(
          label: "Valor do Produto",
          keyboardType: const TextInputType.numberWithOptions(),
          hintText: "R\$ 0,00",
          mask: moneyMaskFormatter,
          hasMask: true,
          controller: controller.priceController,
        ),
        // Campo Valor do Produto e Botão Adicionar

        SizedBox(height: 10,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Selector<EventProductsController, bool>(
              selector: (_, controller) => controller.optionalProduct,
              builder: (context, optionalProduct, child) {
                return Expanded(
                  child: Row(
                    children: [
                      Text("Produto obrigatório"),
                      Switch(
                        value: controller.optionalProduct,
                        onChanged: (value) => controller.setOptionalProduct(value),
                      ),
                    ],
                  ) 
                );
              },
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onPressed: () => controller.addProduct(),
              icon: const Icon(Icons.add),
              label: const Text("Adicionar"),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Lista de produtos adicionados
        Selector<EventProductsController, List<EventProductItem>>(
          selector: (_, controller) => controller.products,
          builder: (context, products, child) {
            if (products.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Nenhum produto adicionado até o momento.",
                  style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              );
            }

            return ListView.builder(
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
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => controller.removeProduct(index),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}