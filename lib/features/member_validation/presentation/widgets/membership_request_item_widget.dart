import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'reject_request_dialog_widget.dart';
import 'request_result_dialog_widget.dart';
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

    return MembershipRequestCardWidget (
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
    final success = await controller.approve(
    request.id,
    professorId,
  );

  if (!context.mounted || !success) {
    return;
  }

    await _showResult(
      context,
      RequestResultType.approved,
    );
  }

  Future<void> _requestChanges(
    BuildContext context,
    MembershipValidationController controller,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) {
        return RequestChangesDialogWidget(
          onConfirm: (reason) {
            return controller.requestChanges(
              request.id,
              reason,
              professorId,
            );
          },
        );
      },
    );

   // Só mostra sucesso se o dialog retornou true
    if (confirmed != true || !context.mounted) {
      return;
    }

    await _showResult(
      context,
      RequestResultType.changesRequested,
    );
  }

  Future<void> _reject(
    BuildContext context,
    MembershipValidationController controller,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) {
        return RejectRequestDialogWidget(
          onConfirm: (reason) {
            return controller.reject(
              request.id,
              reason,
              professorId,
            );
          },
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    await _showResult(
      context,
      RequestResultType.rejected,
    );
  }

  Future<void> _showResult(
    BuildContext context,
    RequestResultType type,
  ) {
    return showDialog(
      context: context,
      builder: (_) {
        return RequestResultDialogWidget (
          type: type,
        );
      },
    );
  }
}