//monta o conteúdo
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import 'request_changes_header_widget.dart';
import '../controllers/request_changes_dialog_controller.dart';
import 'correction_option_widget.dart';
import 'request_changes_actions_widget.dart';

class RequestChangesFormWidget extends StatelessWidget {
  final Future<bool> Function(String reason) onConfirm;

  const RequestChangesFormWidget({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final controller =
        context.read<RequestChangesDialogController>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RequestChangesHeaderWidget(),
        const SizedBox(height: 14),
        const Text(
          'Selecione os dados que precisam ser corrigidos pelo aluno.',
        ),
        const SizedBox(height: 22),

        _option(
          selector: (controller) =>
              controller.beltSelected,
          label: 'Corda incorreta',
          onChanged: controller.toggleBelt,
        ),

        const SizedBox(height: 10),

        _option(
          selector: (controller) =>
              controller.nicknameSelected,
          label: 'Apelido incorreto',
          onChanged: controller.toggleNickname,
        ),

        const SizedBox(height: 10),

        _option(
          selector: (controller) =>
              controller.classSelected,
          label: 'Não pertence à turma',
          onChanged: controller.toggleClass,
        ),

        const SizedBox(height: 22),

        CustomTextInput(
          label: 'Observação',
          controller: controller.detailsController,
          hintText:
              'Adicione mais detalhes, se necessário...',
          maxLines: 3,
          keyboardType: TextInputType.multiline,
        ),

        const SizedBox(height: 24),

        RequestChangesActionsWidget(
          onConfirm: onConfirm,
        ),
      ],
    );
  }

  Widget _option({
    required bool Function(
      RequestChangesDialogController,
    ) selector,
    required String label,
    required ValueChanged<bool> onChanged,
  }) {
    return Selector<
      RequestChangesDialogController,
      bool
    >(
      selector: (_, controller) =>
          selector(controller),
      builder: (context, selected, child) {
        return CorrectionOptionWidget(
          label: label,
          selected: selected,
          onChanged: onChanged,
        );
      },
    );
  }
}