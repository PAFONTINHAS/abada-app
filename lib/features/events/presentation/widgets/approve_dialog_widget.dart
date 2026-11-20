import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/core/utils/app_message_handler.dart';
import 'package:sistema_abada_capoeira/shared/dialogs/controllers/request_justification_dialog_controller.dart';

class ApproveDialogWidget extends StatefulWidget {
  const ApproveDialogWidget({
    super.key,
    required this.onApprove,
  });

  final Future<bool> Function() onApprove;

  @override
  State<ApproveDialogWidget> createState() => _ApproveDialogWidgetState();
}

class _ApproveDialogWidgetState extends State<ApproveDialogWidget> {
  final _submissionController = RequestJustificationDialogController();

  Future<void> _confirm() async {
    if (_submissionController.isSubmitting) return;

    _submissionController.setSubmitting(true);

    try {
      final success = await widget.onApprove();

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pop(true);
      }
    } catch (error, stackTrace) {
      LoggingService.displayError(
        'Approve action failed',
        error: error,
        stack: stackTrace,
      );

      if (!mounted) return;

      AppMessageHandler.showError(
        context,
        'Não foi possível concluir a ação. Tente novamente.',
      );
    } finally {
      if (mounted) {
        _submissionController.setSubmitting(false);
      }
    }
  }

  @override
  void dispose() {
    _submissionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _submissionController,
      builder: (context, child) {
        return AlertDialog(
          backgroundColor: ColorConstants.surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Aprovar Evento",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ColorConstants.textPrimary,
            ),
          ),
          content: const Text(
            "Tem certeza de que deseja aprovar a solicitação deste evento?",
            style: TextStyle(color: ColorConstants.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: _submissionController.isSubmitting
                  ? null
                  : () => Navigator.of(context).pop(false),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
              ),
              onPressed: _submissionController.isSubmitting ? null : _confirm,
              child: _submissionController.isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text("Confirmar Aprovação"),
            ),
          ],
        );
      },
    );
  }
}