import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_products_controller.dart';

class EventMandatorySwitchWidget extends StatelessWidget {
  const EventMandatorySwitchWidget({super.key, required this.controller});

  final EventFormProductsController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Selector<EventFormProductsController, bool>(
          selector: (_, controller) => controller.optionalProduct,
          builder: (context, optionalProduct, child) {
            return Row(
              children: [
                Switch.adaptive(
                  value: controller.optionalProduct,
                  activeThumbColor: ColorConstants.indigoColor,
                  onChanged: (value) => controller.setOptionalProduct(value),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
    );
  }
}
