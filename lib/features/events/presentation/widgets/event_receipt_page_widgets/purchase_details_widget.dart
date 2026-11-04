import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/utils/mask_formatter.dart';
import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/payment_method.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/subscription_status.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_subscription_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_receipt_page_widgets/event_info_row_widget.dart';

class PurchaseDetailsWidget extends StatelessWidget {
  const PurchaseDetailsWidget({super.key, required this.subscription});

  final EventSubscriptionEntity subscription;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Detalhes da Inscrição",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorConstants.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          EventInfoRowWidget(
            label: "Status",
            value: subscription.status.displayPortugueseText,
            isHighlight: true,
          ),
          EventInfoRowWidget(
            label: "Incrito em",
            value: DateController.formatDDMMYYYYHM(subscription.createdAt),
          ),
          EventInfoRowWidget(
            label: "Pagamento",
            value: subscription.paymentMethod.displayPortugueseText,
          ),

          if (subscription.selectedProducts.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              "Produtos Adicionais",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: ColorConstants.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            ...subscription.selectedProducts.map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "- ${p.product}",
                      style: const TextStyle(
                        color: ColorConstants.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: ColorConstants.borderColor),
          ),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Pago",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.textPrimary,
                ),
              ),
              Text(
                MaskFormatter.convertToReais(
                  MaskFormatter.convertMoneyDoubleToString(
                    subscription.totalValue,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.indigoColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
