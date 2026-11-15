import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/utils/mask_formatter.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_products_item.dart';

class MandatoryProductsListWidget extends StatelessWidget {
  const MandatoryProductsListWidget({
    super.key,
    required this.mandatoryProducts,
  });

  final List<EventProductItem> mandatoryProducts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Itens Obrigatórios (Já inclusos)",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: ColorConstants.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        ...mandatoryProducts.map(
          (prod) => Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: ColorConstants.backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: ColorConstants.borderColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  prod.product,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  MaskFormatter.convertToReais(
                    MaskFormatter.convertMoneyDoubleToString(prod.price),
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    color: ColorConstants.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
