import 'package:flutter/material.dart';

class ComplementationReasonCardWidget extends StatelessWidget {
  final String reason;

  const ComplementationReasonCardWidget({super.key, required this.reason});

  static const Color purple = Color(0xFF5936C8);
  static const Color lightPurple = Color(0xFFF5F1FF);
  static const Color darkText = Color(0xFF252334);

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Motivo informado pela TUSCA',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: purple,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            reason,
            style: const TextStyle(fontSize: 13, height: 1.4, color: darkText),
          ),
        ],
      ),
    );
  }
}
