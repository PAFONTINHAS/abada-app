import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_products_item.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_badge_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_products_controller.dart';

class EventProductDetailsWidget extends StatelessWidget {
  const EventProductDetailsWidget({
    super.key,
    required this.product,
    required this.index,
    required this.controller,
  });

  final int index;
  final EventProductItem product;
  final EventFormProductsController controller;
  @override
  Widget build(BuildContext context) {
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
                    EventBadgeWidget(isMandatory: product.mandatory),
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
  }
}
