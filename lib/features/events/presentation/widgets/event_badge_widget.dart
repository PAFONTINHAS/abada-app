import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';

class EventBadgeWidget extends StatelessWidget {
  const EventBadgeWidget({super.key, required this.isMandatory});

  final bool isMandatory;
  @override
  Widget build(BuildContext context) {
    final Color color = isMandatory
        ? ColorConstants.indigoColor
        : ColorConstants.textSecondary;

    final Color bgColor = isMandatory
        ? ColorConstants.indigoLight
        : Colors.black.withOpacity(0.05);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isMandatory ? "Obrigatório" : "Opcional",
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}