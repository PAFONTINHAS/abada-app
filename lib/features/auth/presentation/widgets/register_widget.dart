import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/models/register_phase.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/widgets/form_button_widget.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/register_form_controller.dart';
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

        String registerPhaseTextButton = "Continuar";

        if(registerPhase == RegisterPhase.secondPhase) registerPhaseTextButton = "Cadastrar";

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

              Selector<RegisterFormController, bool>(
                selector: (_, controller) => controller.isFirstPhaseComplete,
                builder: (context, isFirstPhaseComplete, child) {
                  return FormButtonWidget(
                    height: 54,
                    text: registerPhaseTextButton,
                    buttonCollor: isFirstPhaseComplete
                        ? ColorConstants.indigoColor
                        : Colors.grey,
                    onPressed: () {
                      formController.moveToTheNextPhase();
                    },
                  );
              }),

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