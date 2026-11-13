import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/utils/date_formatter.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/tusca_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/tusca_status.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/info_card_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/download_receipt_button_widget.dart';

const Color _primaryPurple = Color(0xFF7C5CBF);
const Color _lightPurple = Color(0xFFF1EDFB);

/// Selo TUSCA
class TuscaSealCardWidget extends StatelessWidget {
  
  final TuscaEntity tuscaEntity;
  final VoidCallback onDownloadReceipt;

  const TuscaSealCardWidget({
    super.key,
    required this.tuscaEntity,
    required this.onDownloadReceipt,
  });

  @override
  Widget build(BuildContext context) {

    final tuscaBadgeImage = tuscaEntity.isRegularTusca
        ? "regular_tusca_badge.png"
        : "irregular_tusca_badge.png";


    final statusLabel = tuscaEntity.isRegularTusca
        ? TuscaStatusExtension.toPortuguese(tuscaEntity.status)
        : "IRREGULAR";

    final statusColor = tuscaEntity.isRegularTusca ? Colors.green : Colors.red;
    final expirationDate = DateFormatter.formatDDMMYYYY(tuscaEntity.validUntil);

    return InfoCardWidget(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: _lightPurple,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                "assets/images/$tuscaBadgeImage",
              )
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selo TUSCA',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        color: statusColor.shade700,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Validade: $expirationDate',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),

                  if(tuscaEntity.isRegularTusca)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 280),
                        child: DownloadReceiptButtonWidget(
                          onDownloadReceipt: onDownloadReceipt,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
