import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/app_spacing.dart';

class MembershipRequestsHeaderWidget extends StatelessWidget {
  final int requestCount;

  const MembershipRequestsHeaderWidget({super.key, required this.requestCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.symmetricH15V10,
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Solicitações pendentes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF252334),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9FE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              requestCount.toString(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5B3FD0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
