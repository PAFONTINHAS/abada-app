import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/shared/dialogs/request_justification_dialog_widget.dart';

/// Configures the shared justification dialog for membership corrections.
class RequestChangesDialogWidget extends StatelessWidget {
  final Future<bool> Function(String justification) onConfirm;

  const RequestChangesDialogWidget({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    // The caller supplies the action; this widget only configures the UI.
    return RequestJustificationDialogWidget(
      title: 'Solicitar correções',
      description: 'Descreva o que precisa ser corrigido na solicitação.',
      hintText: 'Explique as correções necessárias...',
      confirmLabel: 'Enviar correções',
      actionColor: Theme.of(context).colorScheme.primary,
      icon: Icons.edit_outlined,
      onConfirm: onConfirm,
    );
  }
}
