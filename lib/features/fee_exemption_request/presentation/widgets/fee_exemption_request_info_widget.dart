import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/utils/format_date.dart';

import '../../domain/entities/fee_exemption_request_entity.dart';

class FeeExemptionRequestInfoWidget extends StatelessWidget {
  final FeeExemptionRequestEntity request;

  const FeeExemptionRequestInfoWidget({super.key, required this.request});

  static const Color purple = Color(0xFF5936C8);
  static const Color darkText = Color(0xFF252334);
  static const Color secondaryText = Color(0xFF7C7890);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6E1F2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informações da solicitação',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: darkText,
            ),
          ),

          const SizedBox(height: 18),

          _InfoRow(label: 'Professor(a)', value: request.professorName),

          const SizedBox(height: 12),

          const _InfoRow(label: 'Tipo', value: 'Isenção'),

          const SizedBox(height: 12),

          _InfoRow(label: 'Data', value: formatDate(request.requestedAt)),

          const SizedBox(height: 12),

          _InfoRow(
            label: 'Situação',
            value: _statusLabel(request.status.name),
            valueColor: purple,
          ),
        ],
      ),
    );
  }

  

  static String _statusLabel(String status) {
    switch (status) {
      case 'requested':
        return 'Pendente';
      case 'changesRequested':
        return 'Complementação solicitada';
      case 'updated':
        return 'Atualizada';
      case 'approved':
        return 'Aprovada';
      case 'rejected':
        return 'Rejeitada';
      default:
        return status;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF7C7890)),
          ),
        ),

        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? const Color(0xFF252334),
            ),
          ),
        ),
      ],
    );
  }
}
