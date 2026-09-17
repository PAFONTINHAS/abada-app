import 'package:flutter/material.dart';

import '../../domain/entities/fee_exemption_request_entity.dart';
import '../../domain/entities/fee_exemption_request_status_enum.dart';

class FeeExemptionStatusCardWidget extends StatelessWidget {
  final FeeExemptionRequestEntity request;
  final VoidCallback? onComplementation;

  const FeeExemptionStatusCardWidget({
    super.key,
    required this.request,
    this.onComplementation,
  });

  static const Color purple = Color(0xFF5936C8);
  static const Color lightPurple = Color(0xFFF5F1FF);
  static const Color darkText = Color(0xFF252334);
  static const Color secondaryText = Color(0xFF7C7890);

  @override
  Widget build(BuildContext context) {
    switch (request.status) {
      case FeeExemptionStatus.requested:
        return _buildSimpleCard(
          icon: Icons.hourglass_top_outlined,
          title: 'Sua solicitação está em análise',
          message:
              'A TUSCA está analisando a documentação enviada.',
        );

      case FeeExemptionStatus.changesRequested:
        return _buildComplementationCard();

      case FeeExemptionStatus.updated:
        return _buildSimpleCard(
          icon: Icons.check_circle_outline,
          title: 'Complementação enviada',
          message:
              'A nova documentação foi enviada. Aguarde uma nova análise da TUSCA.',
        );

      case FeeExemptionStatus.approved:
        return _buildSimpleCard(
          icon: Icons.verified_outlined,
          title: 'Solicitação aprovada',
          message:
              'Sua solicitação de isenção foi aprovada.',
        );

      case FeeExemptionStatus.rejected:
        return _buildSimpleCard(
          icon: Icons.cancel_outlined,
          title: 'Solicitação rejeitada',
          message:
              'Sua solicitação de isenção foi rejeitada.',
        );
    }
  }

  Widget _buildSimpleCard({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightPurple,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE3DCF7),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: purple,
            size: 24,
          ),
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

  Widget _buildComplementationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightPurple,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE3DCF7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: purple,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Complementação solicitada',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: darkText,
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
              color: secondaryText,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            request.complementationReason ??
                'Nenhum motivo informado.',
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: darkText,
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onComplementation,
              style: FilledButton.styleFrom(
                backgroundColor: purple,
              ),
              child: const Text(
                'Enviar complementação',
              ),
            ),
          ),
        ],
      ),
    );
  }
}