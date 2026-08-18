import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/home_user/presentation/pages/home_user_page.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/widgets/form_button_widget.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/login_form_controller.dart';

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
            // onChanged: (email) => formController.fillEmailField(email),
          ),

          SizedBox(height: 15),

          CustomTextInput(
            label: "Senha",
            prefixIcon: Icon(Icons.password),
            isPasswordField: true,
            hintText: "Digite sua senha",
            controller: formController.passwordController,
            // onChanged: (password) => formController.fillPasswordField(password),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text("Esqueceu a senha?", textAlign: TextAlign.end),
            ),
          ),

          SizedBox(height: 20,),

          FormButtonWidget(
            text: "Entrar",
            height: 52,
            buttonCollor: ColorConstants.indigoColor,
            onPressed: () {},
          ),

          SizedBox(
            height: 35,
            child: Divider(),
          ),

          FormButtonWidget(
            text: "Entrar com o Google",
            height: 52,
            buttonCollor: ColorConstants.whiteColor,
            textColor: Colors.black,
            prefixImagePath: "assets/images/google.png",
            onPressed: (){

              Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeUserPage()));
              
            },
          ),
        ],
      ),
    );
  }
}