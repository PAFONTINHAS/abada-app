import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/utils/message_handler.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/models/register_phase.dart';
import 'package:sistema_abada_capoeira/features/home_user/presentation/pages/home_user_page.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/widgets/form_button_widget.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/register_form_controller.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/widgets/register_phase_based_button.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/widgets/register_phase_progress_widget.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/widgets/register_first_phase_form_widget.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/widgets/register_second_phase_form_widget.dart';

class RegisterWidget extends StatelessWidget {
  const RegisterWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final formController = context.read<RegisterFormController>();
    return Selector<RegisterFormController, RegisterPhase>(
      selector: (_, controller) => controller.registerPhase,
      builder: (context, registerPhase, child){

        return Padding(
          padding: EdgeInsetsGeometry.all(25),
          child: Column(
            children: [
              
              RegisterPhaseProgressWidget(registerPhase: registerPhase),

              SizedBox(height: 15),

              if(registerPhase == RegisterPhase.firstPhase) RegisterFirstPhaseFormWidget(),

              if(registerPhase == RegisterPhase.secondPhase) RegisterSecondPhaseFormWidget(),

              SizedBox(height: 20),

              if(registerPhase == RegisterPhase.secondPhase) SizedBox(height: 40),

              RegisterPhaseBasedButton(
                registerPhase: registerPhase,
                onFirstPhasePressed: () => formController.moveToTheNextPhase(),
                onSecondPhasePressed: () async{

                  MessageHandler.showInfo(context, "Criando sua conta");

                  final success = await formController.registerUser();

                  if(!context.mounted) return;

                  if(!success && formController.errorMessage != null){

                    MessageHandler.showError(context, formController.errorMessage!);

                    return;
                  }

                  MessageHandler.showSuccess(context, "Conta criada com sucesso! Redirecionando...");

                  Navigator.of(context).push(MaterialPageRoute(builder:(context) => HomeUserPage()));

                },
              ),

              SizedBox(height: 20),

              if(registerPhase == RegisterPhase.secondPhase)

                FormButtonWidget(
                  height: 52,
                  text: "Voltar",
                  buttonCollor: ColorConstants.indigoColor,
                  onPressed: () {
                    formController.returnToPreviousPhase();
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}