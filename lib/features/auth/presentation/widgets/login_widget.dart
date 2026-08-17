import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/login_form_controller.dart';
import 'package:sistema_abada_capoeira/shared/buttons/custom_text_button.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final formController = context.read<LoginFormController>();


    return Padding(
      padding: EdgeInsetsGeometry.all(25),
      child: Column(

      children: [

        CustomTextInput(
          label: "Email",
          prefixIcon: Icon(Icons.email_outlined),
          hintText: "seu@email.com",
          controller: formController.emailController,
        ),

        SizedBox(height: 15),

        CustomTextInput(
          label: "Senha",
          prefixIcon: Icon(Icons.password),
          isPasswordField: true,
          hintText: "Digite sua senha",
          controller: formController.passowordController,
        ),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: Text("Esqueceu a senha?", textAlign: TextAlign.end),
          ),
        ),

        SizedBox(height: 20,),


        SizedBox(
          width: double.infinity,
          height: 52,
          child: CustomTextButton(
            text: "Entrar",
            onPressed: () {},
            color: ColorConstants.indigoColor,
            textColor: Colors.white,
            alignment: Alignment.center,
            fontSize: 17,
          ),
        ),

       
      

        Divider(),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: CustomTextButton(
            text: "Entrar Com o Google",
            onPressed: () {},
            color: ColorConstants.whiteColor,
            textColor: Colors.black,
            alignment: Alignment.center,
            fontSize: 17,
            prefixImagePath: "assets/images/google.png",
          ),
        ),



      
      ],

    ),
    );
    
     
  }
}