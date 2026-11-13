import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/utils/date_formatter.dart';

import '../../domain/entities/fee_exemption_document_entity.dart';

class FeeExemptionDocumentCardWidget extends StatelessWidget {
  final FeeExemptionDocumentEntity document;
  final VoidCallback onView;

  const FeeExemptionDocumentCardWidget({
    super.key,
    required this.document,
    required this.onView,
  });

  static const Color purple = Color(0xFF5936C8);
  static const Color darkText = Color(0xFF252334);
  static const Color secondaryText = Color(0xFF7C7890);
  static const Color lightPurple = Color(0xFFF5F1FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6E1F2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Documento enviado',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: darkText,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: lightPurple,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.picture_as_pdf_outlined,
                  color: purple,
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: darkText,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Versão ${document.version}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: secondaryText,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      'Enviado em ${DateFormatter.formatDDMMYYYY(document.uploadedAt)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onView,
              icon: const Icon(Icons.visibility_outlined, size: 18),
              label: const Text('Visualizar'),
              style: TextButton.styleFrom(foregroundColor: purple),
            ),
          ),
        ],
      ),
    );
  }
}
