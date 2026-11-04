import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';

class CreatedEventAlertDialogWidget extends StatelessWidget {
  const CreatedEventAlertDialogWidget({
    super.key,
    required this.title,
    required this.reason,
  });

  final String title;
  final String? reason;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorConstants.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: ColorConstants.textPrimary,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Observação dos avaliadores:",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: ColorConstants.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorConstants.backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: ColorConstants.borderColor),
            ),
            child: Text(
              reason ?? "Sem observações detalhadas.",
              style: const TextStyle(
                color: ColorConstants.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Fechar"),
        ),
      ],
    );
  }
}
