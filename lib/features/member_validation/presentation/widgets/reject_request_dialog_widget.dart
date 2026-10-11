import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/shared/dialogs/request_justification_dialog_widget.dart';

/// Configures the shared justification dialog for membership rejection.
class RejectRequestDialogWidget extends StatelessWidget {
  final Future<bool> Function(String justification) onConfirm;

  const RejectRequestDialogWidget({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    // The caller supplies the action; this widget only configures the UI.
    return RequestJustificationDialogWidget(
      title: 'Recusar solicitação',
      description: 'Informe a justificativa da recusa.',
      hintText: 'Explique o motivo da recusa...',
      confirmLabel: 'Recusar solicitação',
      actionColor: const Color(0xFFEF4444),
      icon: Icons.close,
      onConfirm: onConfirm,
    );
  }
}
