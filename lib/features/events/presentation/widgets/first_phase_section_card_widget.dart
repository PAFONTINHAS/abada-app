import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';

class FirstPhaseSectionCardWidget extends StatelessWidget {
  const FirstPhaseSectionCardWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
        return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConstants.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorConstants.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: ColorConstants.indigoColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.textPrimary,
                ),
              ),
            ],
          ),
          const Divider(height: 24, color: ColorConstants.borderColor),
          ...children,
        ],
      ),
    );
  }
}