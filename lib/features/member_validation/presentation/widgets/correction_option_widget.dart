import 'package:flutter/material.dart';

class CorrectionOptionWidget extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onChanged;

  const CorrectionOptionWidget({
    super.key,
    required this.label,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!selected),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFFFF8EB)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? const Color(0xFFF59E0B)
                : const Color(0xFFE4E1E8),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF252334),
                ),
              ),
            ),
            Checkbox(
              value: selected,
              activeColor: const Color(0xFFF59E0B),
              onChanged: (value) {
                onChanged(value ?? false);
              },
            ),
          ],
        ),
      ),
    );
  }
}