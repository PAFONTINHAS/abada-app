import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/models/event_phases.dart';

class PhaseProgressMarkerWidget extends StatelessWidget {
  const PhaseProgressMarkerWidget({
    super.key,
    required this.phase,
    required this.phaseText,
    required this.phaseColor,
    required this.phaseNumber,
    required this.currentPhase,
    required this.isCompleted,
    this.isLastPhase = false,
  });

  final String phaseText;
  final Color phaseColor;
  final bool isLastPhase;
  final EventPhases phase;
  final String phaseNumber;
  final EventPhases currentPhase;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final bool isFilledBox = currentPhase == phase || isCompleted;

    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isFilledBox
                    ? ColorConstants.indigoColor
                    : ColorConstants.whiteColor,
                border: BoxBorder.all(color: ColorConstants.indigoColor),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: !isCompleted
                    ? Text(
                        phaseNumber,
                        style: TextStyle(
                          fontSize: 17,
                          color: isFilledBox
                              ? ColorConstants.whiteColor
                              : ColorConstants.indigoColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Icon(
                        Icons.check,
                        size: 17,
                        color: ColorConstants.whiteColor,
                      ),
              ),
            ),

            Text(phaseText, style: TextStyle(fontSize: 12)),
          ],
        ),

        if (!isLastPhase)
          Expanded(
            child: Container(
              height: 1,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: !isCompleted
                    ? const Color.fromARGB(62, 79, 39, 211)
                    : ColorConstants.indigoColor,
              ),
            ),
          ),
      ],
    );
  }
}