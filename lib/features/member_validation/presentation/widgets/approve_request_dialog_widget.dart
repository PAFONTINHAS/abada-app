import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/shared/dialogs/request_confirmation_dialog_widget.dart';
import 'package:sistema_abada_capoeira/shared/dialogs/request_dialog_widget.dart';

/// Configures the shared confirmation dialog for membership approval.
class ApproveRequestDialogWidget extends StatelessWidget {
  final Future<bool> Function() onConfirm;

  const ApproveRequestDialogWidget({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    // The caller keeps the approval rules and supplies the action.
    return RequestConfirmationDialogWidget(
      title: 'Aprovar solicitação?',
      description: 'Confirme a aprovação desta solicitação de vínculo.',
      confirmLabel: 'Aprovar',
      actionColor: RequestDialogWidget.approvalColor,
      icon: Icons.check,
      onConfirm: onConfirm,
    );
  }
}
