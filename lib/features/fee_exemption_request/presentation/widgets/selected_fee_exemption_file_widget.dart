import 'package:flutter/material.dart';

class SelectedFeeExemptionFileWidget extends StatelessWidget {
  final String fileName;
  final VoidCallback onRemove;

  const SelectedFeeExemptionFileWidget({
    super.key,
    required this.fileName,
    required this.onRemove,
  });

  static const Color purple = Color(0xFF5936C8);
  static const Color secondaryText = Color(0xFF7C7890);
  static const Color lightPurple = Color(0xFFF5F1FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: lightPurple,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE3DCF7),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.picture_as_pdf_outlined,
            color: purple,
            size: 28,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF252334),
                  ),
                ),

                const SizedBox(height: 2),

                const Text(
                  'PDF selecionado',
                  style: TextStyle(
                    fontSize: 11,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: onRemove,
            icon: const Icon(
              Icons.close,
              size: 20,
            ),
            color: secondaryText,
          ),
        ],
      ),
    );
  }
}