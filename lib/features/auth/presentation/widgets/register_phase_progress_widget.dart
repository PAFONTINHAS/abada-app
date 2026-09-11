import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/models/register_phase.dart';

class RegisterPhaseProgressWidget extends StatelessWidget {
  const RegisterPhaseProgressWidget({super.key, required this.registerPhase});

  final RegisterPhase registerPhase;

  @override
  Widget build(BuildContext context) {

    String firstPhaseFirstStepText = "1";

    Color firstPhaseSecondStepColor = ColorConstants.indigoColor;
    Color secondPhaseSecondStepColor = ColorConstants.whiteColor;

    bool isFirstPhase = registerPhase == RegisterPhase.firstPhase;


    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: ColorConstants.indigoColor,
            border: BoxBorder.all(color: ColorConstants.indigoColor),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isFirstPhase 
              ?
                Text(
                  firstPhaseFirstStepText,
                  style: TextStyle(
                    fontSize: 17,
                    color: ColorConstants.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                )
              :  
                Icon(
                  Icons.check, 
                  size: 17, 
                  color: ColorConstants.whiteColor
                )
          ),
        ),

        Container(
          width: 45,
          height: 1,
          decoration: BoxDecoration(
            color: isFirstPhase
                ? const Color.fromARGB(62, 79, 39, 211)
                : ColorConstants.indigoColor,
          ),
        ),

        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isFirstPhase ? const Color.fromARGB(108, 211, 211, 211) : ColorConstants.indigoColor,
            border: BoxBorder.all(color: ColorConstants.indigoColor),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              "2",
              style: TextStyle(
                fontSize: 17,
                color: isFirstPhase ? firstPhaseSecondStepColor : secondPhaseSecondStepColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

