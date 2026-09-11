import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/register_form_controller.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/models/register_phase.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/widgets/form_button_widget.dart';

class RegisterPhaseBasedButton extends StatelessWidget {

  const RegisterPhaseBasedButton({
    super.key,
    required this.registerPhase,
    required this.onFirstPhasePressed,
    required this.onSecondPhasePressed,
  });

  final RegisterPhase registerPhase;
  final VoidCallback onFirstPhasePressed;
  final VoidCallback onSecondPhasePressed;

  @override
  Widget build(BuildContext context) {
    String registerPhaseTextButton = "Continuar";

    final VoidCallback onPressed = 
      registerPhase == RegisterPhase.firstPhase 
        ? onFirstPhasePressed 
        : onSecondPhasePressed;

    
    return Selector<RegisterFormController, bool>(
      selector: (_, controller) => controller.isFirstPhaseComplete,
      builder: (context, isFirstPhaseComplete, child) {

        final Color buttonCollor = isFirstPhaseComplete ? ColorConstants.indigoColor : Colors.grey;

        if (isFirstPhaseComplete && registerPhase == RegisterPhase.secondPhase) registerPhaseTextButton = "Cadastrar";

        return FormButtonWidget(
          height: 54,
          text: registerPhaseTextButton,
          buttonCollor: buttonCollor,
          onPressed: onPressed
        );
      },
    );

  }
}