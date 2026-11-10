import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_details_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/approve_dialog_widget.dart';
import 'package:sistema_abada_capoeira/shared/dialogs/request_justification_dialog_widget.dart';

class EventDetailsModals {
  EventDetailsModals._();

  static Future<void> showConfirmApproveDialog(
    BuildContext context,
    EventDetailsController controller,
  ) async {
    showDialog(
      context: context,
      builder: (context) => ApproveDialogWidget(onApprove: () => context.pop()),
    );
  }

  static Future<void> showReasonModal({
    required BuildContext context,
    required String title,
    required String labelText,
    required Color buttonColor,
    required Future<bool> Function(String reason) onSubmit,
  }) async {
    showDialog<bool>(
      context: context,
      builder: (context) => RequestJustificationDialogWidget(
        title: title,
        hintText: labelText,
        confirmLabel: 'Confirmar e Enviar',
        actionColor: buttonColor,
        icon: Icons.edit_outlined,
        onConfirm: onSubmit,
      ),
    );
  }
}
