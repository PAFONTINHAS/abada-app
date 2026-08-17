import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/register_form_controller.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input.dart';

class RegisterFirstPhaseFormWidget extends StatelessWidget {
  const RegisterFirstPhaseFormWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final phoneMaskFormatter = MaskTextInputFormatter(
      mask:"(##) #####-####",
      filter: {'#': RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy
    );
    
    final formController = context.read<RegisterFormController>();
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            "Dados Pessoais",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),

        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Preencha suas informações para criar sua conta",
              style: TextStyle(fontSize: 17),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        SizedBox(height: 15),

        CustomTextInput(
          label: "Nome Completo",
          prefixIcon: Icon(Icons.person_2_outlined),
          hintText: "Digite seu nome",
          controller: formController.fullNameController,
        ),

        SizedBox(height: 15),

        CustomTextInput(
          label: "Email",
          prefixIcon: Icon(Icons.email_outlined),
          hintText: "seu@email.com",
          controller: formController.emailController,
          keyboardType: TextInputType.emailAddress,
        ),

        SizedBox(height: 15),

        CustomTextInput(
          label: "Telefone",
          prefixIcon: Icon(Icons.phone_outlined),
          hintText: "(11) 999999-9999",
          controller: formController.phoneController,
          mask: phoneMaskFormatter,
          keyboardType: TextInputType.number,
          hasMask: true,
        ),

        SizedBox(height: 15),

        CustomTextInput(
          label: "Senha",
          prefixIcon: Icon(Icons.password),
          isPasswordField: true,
          hintText: "Digite sua senha",
          controller: formController.passwordController,
          keyboardType: TextInputType.visiblePassword,
        ),

        SizedBox(height: 15),

        CustomTextInput(
          label: "Confirmar Senha",
          prefixIcon: Icon(Icons.password),
          isPasswordField: true,
          hintText: "Confirme sua senha",
          controller: formController.confirmPasswordController,
          keyboardType: TextInputType.visiblePassword,
        ),

        SizedBox(height: 15),
      ],
    );
  }
}
