import 'package:flutter/material.dart';

class FeeExemptionHeaderWidget extends StatelessWidget {
  const FeeExemptionHeaderWidget({super.key});

  static const Color purple = Color(0xFF5936C8);
  static const Color secondaryText = Color(0xFF7C7890);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              color: const Color(0xFF252334),
            ),

            const Expanded(
              child: Text(
                'Solicitar Isenção',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: purple,
                ),
              ),
            ),

            // Mantém o título realmente centralizado.
            const SizedBox(width: 48),
          ],
        ),

        const SizedBox(height: 4),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            'Solicite sua isenção de taxas enviando a declaração '
            'padrão preenchida e assinada.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, height: 1.4, color: secondaryText),
          ),
        ),
      ],
    );
  }
}
