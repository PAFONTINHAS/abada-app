import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/action_title_widget.dart';

const Color _primaryPurple = Color(0xFF7C5CBF);

/// "Ações rápidas" agrupa cada item de action_title_widget

class QuickActionsSectionWidget extends StatelessWidget {
  final VoidCallback onRequestExemption;
  final VoidCallback onPayFee;

  const QuickActionsSectionWidget({
    super.key,
    required this.onRequestExemption,
    required this.onPayFee,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ações rápidas',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ActionTitleWidget(
                icon: Icons.description_outlined,
                label: 'Solicitar isenção',
                subtitle: 'Peça a isenção da taxa TUSCA',
                accentColor: _primaryPurple,
                onTap: onRequestExemption,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ActionTitleWidget(
                icon: Icons.diamond_outlined,
                label: 'Pagar taxa',
                subtitle: 'Pagar taxa TUSCA por pix ou boleto',
                accentColor: Colors.black87,
                onTap: onPayFee,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
