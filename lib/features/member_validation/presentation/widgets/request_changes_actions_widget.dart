//botões de ação do dialog
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/message_handler.dart';
import '../controllers/request_changes_dialog_controller.dart';

class RequestChangesActionsWidget extends StatelessWidget {
  final Future<bool> Function(String reason) onConfirm;

  const RequestChangesActionsWidget({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<RequestChangesDialogController, bool>(
      selector: (_, controller) => controller.isLoading,
      builder: (context, isLoading, child) {
        return Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: isLoading
                    ? null
                    : () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: isLoading
                    ? null
                    : () => _confirm(context),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Enviar correções'),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirm(BuildContext context) async {
    final controller =
        context.read<RequestChangesDialogController>();

    final error = controller.validate();

    if (error != null) {
      MessageHandler.showWarning(context, error);
      return;
    }

    final success = await controller.confirm(onConfirm);

    if (!context.mounted || !success) {
      return;
    }

    Navigator.of(context).pop(true);
  }
}