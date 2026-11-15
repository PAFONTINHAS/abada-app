import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/utils/abada_belts.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_minor_subscription_controller.dart';
import 'package:sistema_abada_capoeira/shared/inputs/dropdown_input_widget.dart';

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

    final studentBelts = AbadaBelts.belts.students().map((studentBelt) {
      return DropdownMenuItem<String>(
        value: studentBelt.belt,
        child: Text(studentBelt.belt, overflow: TextOverflow.ellipsis),
      );
    }).toList();

    final initialDropdownValue =  controller.studentGraduationController.text;

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
              child: DropdownInputWidget(
                inputHint: "Corda Atual",
                menuMaxHeight: 250,
                initialValue: initialDropdownValue,
                items: studentBelts,
                onSelectedItem: (belt) {
                  if (belt == null) return;
                  controller.setStudentGraduation(belt);
                },
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

        // --- SEÇÃO: DADOS DO RESPONSÁVEL LEGAL ---dfdf
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
          keyboardType: const TextInputType.numberWithOptions(),
          hintText: "Telefone/Whatsapp do Responsável",
          hasMask: true,
          mask: phoneMaskFormatter,
          controller: controller.guardianPhoneController,
        ),
      ],
    );
  }
}
