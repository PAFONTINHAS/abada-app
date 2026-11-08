import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/utils/mask_formatter.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_details_subscription_controller.dart';

class TotalSubscriptionValueWidget extends StatelessWidget {
  const TotalSubscriptionValueWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<EventDetailsSubscriptionController>();

    final formattedTotal = controller.totalAmount == 0.0
        ? 'GRATUITO'
        : MaskFormatter.convertToReais(
            MaskFormatter.convertMoneyDoubleToString(controller.totalAmount),
          );
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Valor Total a Pagar:",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: ColorConstants.textPrimary,
              ),
            ),
            Text(
              formattedTotal,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
