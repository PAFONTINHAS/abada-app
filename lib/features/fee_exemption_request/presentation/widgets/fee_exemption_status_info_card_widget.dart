import 'package:flutter/material.dart';

class FeeExemptionStatusInfoCardWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const FeeExemptionStatusInfoCardWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  static const Color purple = Color(0xFF5936C8);
  static const Color lightPurple = Color(0xFFF5F1FF);
  static const Color darkText = Color(0xFF252334);
  static const Color secondaryText = Color(0xFF7C7890);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightPurple,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE3DCF7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: purple, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
