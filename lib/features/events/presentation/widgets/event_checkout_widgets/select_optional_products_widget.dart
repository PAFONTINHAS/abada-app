import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/utils/mask_formatter.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_products_item.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_details_subscription_controller.dart';

class SelectOptionalProductsWidget extends StatelessWidget {
  const SelectOptionalProductsWidget({
    super.key,
    required this.optionalProducts,
  });

  final List<EventProductItem> optionalProducts;

  @override
  Widget build(BuildContext context) {
    return Consumer<EventDetailsSubscriptionController>(
      builder: (context, controller, child) {
        return Column(
          children: [
            const Text(
              "Adicionar Produtos Opcionais",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: ColorConstants.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            ...optionalProducts.map((product) {
              final isSelected = controller.selectedOptionalProducts.contains(
                product,
              );
              return CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                activeColor: Colors.green.shade700,
                title: Text(
                  product.product,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  MaskFormatter.convertToReais(
                    MaskFormatter.convertMoneyDoubleToString(product.price),
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    color: ColorConstants.textSecondary,
                  ),
                ),
                value: isSelected,
                onChanged: (checked) {
                  
                  if(checked == true){
                    controller.addOptionalProduct(product);
                  } else{
                    controller.removeOptionalProduct(product);
                  }
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
