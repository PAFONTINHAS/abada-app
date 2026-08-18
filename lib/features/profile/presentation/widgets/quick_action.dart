import 'package:flutter/material.dart';

const Color _primaryPurple = Color(0xFF7C5CBF);

/// "Ações rápidas" agrupa cada item de action_title

class QuickActionsSection extends StatelessWidget {
  final VoidCallback onRequestExemption;
  final VoidCallback onPayFee;

  const QuickActionsSection({
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
              child: _ActionTitle(
                icon: Icons.description_outlined,
                label: 'Solicitar isenção',
                subtitle: 'Peça a isenção da taxa TUSCA',
                accentColor: _primaryPurple,
                onTap: onRequestExemption,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionTitle(
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

class _ActionTitle extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color accentColor;
  final VoidCallback onTap;

  const _ActionTitle({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accentColor.withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              Icon(icon, color: accentColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
