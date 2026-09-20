import 'package:flutter/material.dart';

import '../../domain/entities/fee_exemption_request_entity.dart';
import '../../domain/entities/fee_exemption_request_status_enum.dart';
import 'fee_exemption_complementation_status_card_widget.dart';
import 'fee_exemption_status_info_card_widget.dart';

class FeeExemptionStatusCardWidget extends StatelessWidget {
  final FeeExemptionRequestEntity request;
  final VoidCallback onComplementation;

  const FeeExemptionStatusCardWidget({
    super.key,
    required this.request,
    required this.onComplementation,
  });

  @override
  Widget build(BuildContext context) {
    switch (request.status) {
      case FeeExemptionStatus.requested:
        return const FeeExemptionStatusInfoCardWidget(
          icon: Icons.hourglass_top_outlined,
          title: 'Sua solicitação está em análise',
          message: 'A TUSCA está analisando a documentação enviada.',
        );

      case FeeExemptionStatus.changesRequested:
        return FeeExemptionComplementationStatusCardWidget(
          complementationReason: request.complementationReason,
          onComplementation: onComplementation,
        );

      case FeeExemptionStatus.updated:
        return const FeeExemptionStatusInfoCardWidget(
          icon: Icons.check_circle_outline,
          title: 'Complementação enviada',
          message:
              'A nova documentação foi enviada. Aguarde uma nova análise da TUSCA.',
        );

      case FeeExemptionStatus.approved:
        return const FeeExemptionStatusInfoCardWidget(
          icon: Icons.verified_outlined,
          title: 'Solicitação aprovada',
          message: 'Sua solicitação de isenção foi aprovada.',
        );

      case FeeExemptionStatus.rejected:
        return const FeeExemptionStatusInfoCardWidget(
          icon: Icons.cancel_outlined,
          title: 'Solicitação rejeitada',
          message: 'Sua solicitação de isenção foi rejeitada.',
        );
    }
  }
}
