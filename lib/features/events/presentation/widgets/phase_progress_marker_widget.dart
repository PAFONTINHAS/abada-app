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
    final bool isActive = currentPhase == phase;
    final bool isFilled = isActive || isCompleted;

    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isFilled
                    ? ColorConstants.indigoColor
                    : ColorConstants.surfaceColor,
                border: Border.all(
                  color: isFilled
                      ? ColorConstants.indigoColor
                      : ColorConstants.borderColor,
                  width: 2,
                ),
                shape: BoxShape.circle,
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: ColorConstants.indigoColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : [],
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(
                        Icons.check_rounded,
                        size: 18,
                        color: ColorConstants.whiteColor,
                      )
                    : Text(
                        phaseNumber,
                        style: TextStyle(
                          fontSize: 14,
                          color: isFilled
                              ? ColorConstants.whiteColor
                              : ColorConstants.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              phaseText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive
                    ? ColorConstants.indigoColor
                    : ColorConstants.textSecondary,
              ),
            ),
          ],
        ),
        if (!isLastPhase)
          Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.only(bottom: 20, left: 8, right: 8),
              color: isCompleted
                  ? ColorConstants.indigoColor
                  : ColorConstants.borderColor,
            ),
          ),
      ],
    );
  }
}