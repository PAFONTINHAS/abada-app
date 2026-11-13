import 'package:flutter/material.dart';

const Color _primaryPurple = Color(0xFF7C5CBF);

class DownloadReceiptButtonWidget extends StatelessWidget {
  final VoidCallback onDownloadReceipt;

  const DownloadReceiptButtonWidget({
    super.key,
    required this.onDownloadReceipt,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDownloadReceipt,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8E3F3)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.download_rounded, size: 14, color: _primaryPurple),
            SizedBox(width: 6),
            Flexible(
              child: Text(
                'Baixar comprovante',
                softWrap: true,
                style: TextStyle(
                  color: _primaryPurple,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
