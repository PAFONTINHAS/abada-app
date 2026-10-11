import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'approve_request_dialog_widget.dart';
import 'reject_request_dialog_widget.dart';
import 'package:sistema_abada_capoeira/shared/dialogs/action_success_dialog_widget.dart';
import '../controllers/request_result_controller.dart';
import 'request_changes_dialog_widget.dart';
import '../models/request_result_type.dart';
import 'membership_request_card_widget.dart';
import '../../domain/entities/membership_request.dart';
import '../controllers/membership_validation_controller.dart';

class MembershipRequestItemWidget extends StatelessWidget {
  final MembershipRequest request;
  final String professorId;

  const MembershipRequestItemWidget({
    super.key,
    required this.request,
    required this.professorId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.read<MembershipValidationController>();

    return MembershipRequestCardWidget(
      request: request,
      onApprove: () => _approve(context, controller),
      onRequestChanges: () => _requestChanges(context, controller),
      onReject: () => _reject(context, controller),
    );
  }

  Future<void> _approve(
    BuildContext context,
    MembershipValidationController controller,
  ) async {
    // The root navigator stays mounted when loading removes this list item.
    final resultContext = Navigator.of(context, rootNavigator: true).context;
    // Approval runs only after confirmation; the feature keeps its controller.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => ApproveRequestDialogWidget(
        onConfirm: () => controller.approve(request, professorId),
      ),
    );

    if (!resultContext.mounted || confirmed != true) {
      return;
    }

    await _showResult(resultContext, RequestResultType.approved);
  }

  Future<void> _requestChanges(
    BuildContext context,
    MembershipValidationController controller,
  ) async {
    final resultContext = Navigator.of(context, rootNavigator: true).context;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) {
        return RequestChangesDialogWidget(
          onConfirm: (reason) {
            return controller.requestChanges(request.id, reason, professorId);
          },
        );
      },
    );

    // Show success only after the action dialog returns true.
    if (confirmed != true || !resultContext.mounted) {
      return;
    }

    await _showResult(resultContext, RequestResultType.changesRequested);
  }

  Future<void> _reject(
    BuildContext context,
    MembershipValidationController controller,
  ) async {
    final resultContext = Navigator.of(context, rootNavigator: true).context;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) {
        return RejectRequestDialogWidget(
          onConfirm: (reason) {
            return controller.reject(request.id, reason, professorId);
          },
        );
      },
    );

    if (confirmed != true || !resultContext.mounted) {
      return;
    }

    await _showResult(resultContext, RequestResultType.rejected);
  }

  Future<void> _showResult(BuildContext context, RequestResultType type) {
    final resultData = RequestResultController().getResultData(type);
    return showDialog<void>(
      context: context,
      builder: (_) {
        return ActionSuccessDialogWidget(
          title: resultData.title,
          message: resultData.message,
        );
      },
    );
  }
}
