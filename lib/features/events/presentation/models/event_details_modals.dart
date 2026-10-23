import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_details_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/approve_dialog_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/show_reason_modal_widget.dart';

class EventDetailsModals {

  EventDetailsModals._();

  static Future<void> showConfirmApproveDialog(BuildContext context, EventDetailsController controller) async {
    showDialog(
      context: context,
      builder: (context) => ApproveDialogWidget(
        onApprove: () => context.pop() 
      )
    );
  }

  static Future<void> showReasonModal({
    required BuildContext context,
    required String title,
    required String labelText,
    required Color buttonColor,
    required Function(String reason) onSubmit,

  }) async {

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorConstants.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ShowReasonModalWidget(
        title: title,
        onSubmit: onSubmit,
        labelText: labelText,
        buttonColor: buttonColor,
      )
    );
  }



}