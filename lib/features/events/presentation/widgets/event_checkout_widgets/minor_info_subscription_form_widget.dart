import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_minor_subscription_controller.dart';

class MinorInfoSubscriptionFormWidget extends StatelessWidget {
  const MinorInfoSubscriptionFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<EventMinorSubscriptionController>();
    final phoneMaskFormatter = MaskTextInputFormatter(
      mask: "(##) #####-####",
      filter: {'#': RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Preencha os dados do menor e do responsável legal antes de prosseguir.",
          style: TextStyle(fontSize: 12, color: ColorConstants.textSecondary),
        ),
        const SizedBox(height: 16),

        // --- SEÇÃO: DADOS DO MENOR ---
        const Text(
          "Dados do Aluno (Menor)",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: ColorConstants.textPrimary,
          ),
        ),
        const SizedBox(height: 10),

        CustomTextInput(
          hintText: "Nome completo do Menor",
          controller: controller.studentNameController,
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: CustomTextInput(
                hintText: "Corda Atual",
                controller: controller.studentGraduationController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextInput(
                hintText: "Apelido (Opcional)",
                controller: controller.studentNicknameController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // --- SEÇÃO: DADOS DO RESPONSÁVEL LEGAL ---
        const Text(
          "Dados do Responsável Legal",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: ColorConstants.textPrimary,
          ),
        ),
        const SizedBox(height: 10),

        CustomTextInput(
          hintText: "Nome do Responsável",
          controller: controller.guardianNameController,
        ),

        const SizedBox(height: 12),

        CustomTextInput(
          keyboardType: TextInputType.numberWithOptions(),
          hintText: "Telefone/Whatsapp do Responsável",
          hasMask: true,
          mask: phoneMaskFormatter,
          controller: controller.guardianPhoneController,
        ),
      ],
    );
  }
}
