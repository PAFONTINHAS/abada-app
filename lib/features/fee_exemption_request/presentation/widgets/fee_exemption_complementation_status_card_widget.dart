import 'package:flutter/material.dart';

class FeeExemptionComplementationStatusCardWidget extends StatelessWidget {
  final String? complementationReason;
  final VoidCallback onComplementation;

  const FeeExemptionComplementationStatusCardWidget({
    super.key,
    required this.complementationReason,
    required this.onComplementation,
  });

  static const Color _purple = Color(0xFF5936C8);
  static const Color _lightPurple = Color(0xFFF7F4FF);
  static const Color _darkText = Color(0xFF252334);
  static const Color _secondaryText = Color(0xFF7C7890);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _lightPurple,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE3DCF7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: _purple),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Complementação solicitada',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _darkText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Motivo informado pela TUSCA',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _secondaryText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            complementationReason ?? 'Nenhum motivo informado.',
            style: const TextStyle(fontSize: 13, height: 1.4, color: _darkText),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onComplementation,
              style: FilledButton.styleFrom(backgroundColor: _purple),
              child: const Text('Enviar complementação'),
            ),
          ),
        ],
      ),
    );
  }
}
