import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/features/member_validation/presentation/controllers/request_changes_dialog_controller.dart';
import 'package:sistema_abada_capoeira/features/member_validation/presentation/widgets/request_changes_form_widget.dart';

class RequestChangesDialogWidget extends StatelessWidget {
  final Future<bool> Function(String reason) onConfirm;

  const RequestChangesDialogWidget({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RequestChangesDialogController(),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: SingleChildScrollView(
            child: RequestChangesFormWidget(
              onConfirm: onConfirm,
            ),
          ),
        ),
      ),
    );
  }
}