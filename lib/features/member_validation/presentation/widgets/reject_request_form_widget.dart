import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import '../controllers/reject_request_dialog_controller.dart';
import 'reject_reason_option_widget.dart';
import 'reject_request_actions_widget.dart';

class RejectRequestFormWidget extends StatelessWidget {
  final Future<bool> Function(String reason) onConfirm;

  const RejectRequestFormWidget({
    super.key,
    required this.onConfirm,
  });

  static const Color red = Color(0xFFEF4444);
  static const Color darkText = Color(0xFF252334);
  static const Color secondaryText = Color(0xFF6B6877);

  @override
  Widget build(BuildContext context) {
    final controller =
        context.read<RejectRequestDialogController>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),

        const SizedBox(height: 14),

        const Text(
          'Selecione o motivo da recusa.',
          style: TextStyle(
            fontSize: 14,
            height: 1.4,
            color: secondaryText,
          ),
        ),

        const SizedBox(height: 22),

        Selector<RejectRequestDialogController, String?>(
          selector: (_, controller) =>
              controller.selectedReason,
          builder: (context, selectedReason, child) {
            return RejectReasonOptionWidget(
              label: 'Não pertence à ABADÁ',
              selected:
                  selectedReason == 'Não pertence à ABADÁ',
              onTap: () {
                controller.selectReason(
                  'Não pertence à ABADÁ',
                );
              },
            );
          },
        ),

        const SizedBox(height: 10),

        Selector<RejectRequestDialogController, String?>(
          selector: (_, controller) =>
              controller.selectedReason,
          builder: (context, selectedReason, child) {
            return RejectReasonOptionWidget(
              label: 'Outro motivo',
              selected: selectedReason == 'Outro motivo',
              onTap: () {
                controller.selectReason(
                  'Outro motivo',
                );
              },
            );
          },
        ),

        Selector<RejectRequestDialogController, String?>(
          selector: (_, controller) =>
              controller.selectedReason,
          builder: (context, selectedReason, child) {
            if (selectedReason != 'Outro motivo') {
              return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                const Text(
                  'Motivo da rejeição',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: darkText,
                  ),
                ),

                const SizedBox(height: 8),

                CustomTextInput(
                  controller:
                      controller.otherReasonController,
                  hintText:
                      'Especifique o motivo da rejeição...',
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFA3A0AA),
                  ),
                  maxLines: 3,
                  keyboardType:
                      TextInputType.multiline,
                  onFocusBorderColor: red,
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 24),

        RejectRequestActionsWidget(
          onConfirm: onConfirm,
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFFFEEEE),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.close,
            color: red,
            size: 22,
          ),
        ),

        const SizedBox(width: 12),

        const Expanded(
          child: Text(
            'Recusar solicitação',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: darkText,
            ),
          ),
        ),

        Selector<RejectRequestDialogController, bool>(
          selector: (_, controller) =>
              controller.isLoading,
          builder: (context, isLoading, child) {
            return IconButton(
              onPressed: isLoading
                  ? null
                  : () {
                      Navigator.of(context).pop();
                    },
              icon: const Icon(Icons.close, size: 21),
              color: secondaryText,
            );
          },
        ),
      ],
    );
  }
}