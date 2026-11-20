import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/utils/mask_formatter.dart';

class RevisionPhaseFinancialSummaryWidget extends StatelessWidget {
  const RevisionPhaseFinancialSummaryWidget({
    super.key,
    required this.totalEventValue,
  });

  final String totalEventValue;

  @override
  Widget build(BuildContext context) {
    bool isFree = totalEventValue == "0.00";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConstants.indigoLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorConstants.indigoColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: ColorConstants.indigoColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.payments_outlined,
              color: ColorConstants.whiteColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Valor Total Estimado",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.indigoDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isFree ? 'GRATUITO' : MaskFormatter.convertToReais(totalEventValue),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.indigoColor,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Inclui inscrição e produtos obrigatórios",
                  style: TextStyle(
                    fontSize: 11,
                    color: ColorConstants.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
