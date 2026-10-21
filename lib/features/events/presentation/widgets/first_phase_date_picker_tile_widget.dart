import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';

class FirstPhaseDatePickerTile extends StatelessWidget {
  final String label;
  final Widget selector;
  final VoidCallback onTap;

  const FirstPhaseDatePickerTile({
    super.key,
    required this.label,
    required this.selector,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: ColorConstants.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorConstants.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: ColorConstants.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(child: selector),
                const Icon(
                  Icons.access_time_rounded,
                  size: 16,
                  color: ColorConstants.indigoColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}