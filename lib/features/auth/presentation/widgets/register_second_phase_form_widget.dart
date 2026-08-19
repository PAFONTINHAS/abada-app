import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/register_form_controller.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';

class RegisterSecondPhaseFormWidget extends StatelessWidget {
  const RegisterSecondPhaseFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final formController = context.read<RegisterFormController>();
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            "Mais Informações",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),

        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Complete seus dados para finalizar o cadastro",
              style: TextStyle(fontSize: 17),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        CustomTextInput(
          label: "Apelido",
          prefixIcon: Icon(Icons.person_2_outlined),
          hintText: "Digite seu apelido",
          controller: formController.nicknameController,
        ),

        SizedBox(height: 15),

        CustomTextInput(
          label: "Corda",
          prefixIcon: Icon(Icons.linear_scale),
          hintText: "Digite sua corda",
          controller: formController.ropeController,
        ),

        SizedBox(height: 15),

        CustomTextInput(
          label: "Professor",
          prefixIcon: Icon(Icons.group_outlined),
          hintText: "Selecione o seu professor",
          controller: formController.professorController,
        ),
      ],
    );
  }
}
