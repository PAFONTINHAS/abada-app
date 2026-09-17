import 'package:flutter/material.dart';

class FeeExemptionInfoCardWidget extends StatelessWidget {
  const FeeExemptionInfoCardWidget({super.key});

  static const Color purple = Color(0xFF5936C8);
  static const Color lightPurple = Color(0xFFF5F1FF);
  static const Color secondaryText = Color(0xFF6F6B7C);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightPurple,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3DCF7)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: purple, size: 22),

          SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Importante',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: purple,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  'Sua solicitação será analisada pela TUSCA. '
                  'Acompanhe o status pelo aplicativo.',
                  style: TextStyle(
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
