import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/message_handler.dart';
import '../controllers/reject_request_dialog_controller.dart';

class RejectRequestActionsWidget extends StatelessWidget {
  final Future<bool> Function(String reason) onConfirm;

  const RejectRequestActionsWidget({
    super.key,
    required this.onConfirm,
  });

  static const Color red = Color(0xFFEF4444);
  static const Color darkText = Color(0xFF252334);

  @override
  Widget build(BuildContext context) {
    return Selector<RejectRequestDialogController, bool>(
      selector: (_, controller) => controller.isLoading,
      builder: (context, isLoading, child) {
        return Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  style: TextButton.styleFrom(
                    foregroundColor: darkText,
                  ),
                  child: const Text('Cancelar'),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              flex: 2,
              child: SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: isLoading
                      ? null
                      : () => _confirm(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: red,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Recusar solicitação',
                        ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirm(BuildContext context) async {
    final controller =
        context.read<RejectRequestDialogController>();

    final error = controller.validate();

    if (error != null) {
      MessageHandler.showWarning(
        context,
        error,
      );
      return;
    }

    final success = await controller.confirm(onConfirm);

    if (!context.mounted || !success) {
      return;
  }

    Navigator.of(context).pop(true);
  }
}