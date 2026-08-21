import 'package:flutter/material.dart';

class PendingStatusBadge extends StatelessWidget {
  const PendingStatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF2EDFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.hourglass_empty,
            size: 15,
            color: Color(0xFF5424D6),
          ),
          SizedBox(width: 6),
          Text(
            'Pendente',
            style: TextStyle(
              color: Color(0xFF5424D6),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}