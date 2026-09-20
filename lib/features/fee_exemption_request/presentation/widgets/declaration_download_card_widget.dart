import 'package:flutter/material.dart';

class DeclarationDownloadCardWidget extends StatelessWidget {
  final VoidCallback onTap;

  const DeclarationDownloadCardWidget({super.key, required this.onTap});

  static const Color purple = Color(0xFF5936C8);
  static const Color secondaryText = Color(0xFF7C7890);
  static const Color lightPurple = Color(0xFFF3EEFF);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE6E1F2)),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                color: lightPurple,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_download_outlined,
                color: purple,
                size: 26,
              ),
            ),

            const SizedBox(width: 14),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Baixar declaração padrão',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF252334),
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    'Faça o download do modelo oficial '
                    'da declaração da ABADÁ.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      color: secondaryText,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            const Icon(Icons.chevron_right, color: Color(0xFF252334)),
          ],
        ),
      ),
    );
  }
}
