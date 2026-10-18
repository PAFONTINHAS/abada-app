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
import 'package:sistema_abada_capoeira/core/utils/message_handler.dart';

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

  Future<bool> _handleAction(
    BuildContext context,
    MembershipValidationController controller,
    Future<bool> Function() action,
  ) async {
    final success = await action();

    if (!success && context.mounted) {
      MessageHandler.showError(
        context,
        controller.actionErrorMessage ??
            'Não foi possível concluir a operação. Tente novamente.',
      );
    }

    return success;
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
        onConfirm: () => _handleAction(
          resultContext,
          controller,
          () => controller.approve(request, professorId),
        ),
      ),
    );

    if (!resultContext.mounted || confirmed != true) {
      return;
    }

    await _showResult(resultContext, RequestResultType.approved);
    await controller.loadRequests(professorId);
    //a lista só será atualizada quando o usuário fechar o modal de resultado.
    //Isso evita que o card seja removido enquanto os diálogos estão abertos.
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
          onConfirm: (reason) => _handleAction(
            resultContext,
            controller,
            () => controller.requestChanges(request.id, reason, professorId),
          ),
        );
      },
    );

    // Show success only after the action dialog returns true.
    if (confirmed != true || !resultContext.mounted) {
      return;
    }

    await _showResult(resultContext, RequestResultType.changesRequested);
    await controller.loadRequests(professorId);
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
          onConfirm: (reason) => _handleAction(
            resultContext,
            controller,
            () => controller.reject(request.id, reason, professorId),
          ),
        );
      },
    );

    if (confirmed != true || !resultContext.mounted) {
      return;
    }

    await _showResult(resultContext, RequestResultType.rejected);
    await controller.loadRequests(professorId);
  }

  Future<void> _showResult(BuildContext context, RequestResultType type) {
    final resultData = RequestResultController().getResultData(type);

    return showDialog<void>(
      context: context,
      builder: (_) => ActionSuccessDialogWidget(
        title: resultData.title,
        message: resultData.message,
        icon: resultData.icon,
        iconColor: resultData.iconColor,
        backgroundColor: resultData.backgroundColor,
      ),
    );
  }
}
