import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';

class ApproveDialogWidget extends StatelessWidget {
  const ApproveDialogWidget({super.key, required this.onApprove});

  final VoidCallback onApprove;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorConstants.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Aprovar Evento",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: ColorConstants.textPrimary,
        ),
      ),
      content: const Text(
        "Tem certeza de que deseja aprovar a publicação deste evento?",
        style: TextStyle(color: ColorConstants.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
          ),
          onPressed: onApprove,
          child: const Text("Confirmar Aprovação"),
        ),
      ],
    );
  }
}
