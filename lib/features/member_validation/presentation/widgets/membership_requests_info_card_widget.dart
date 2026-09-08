import 'package:flutter/material.dart';

class MembershipRequestsInfoCardWidget extends StatelessWidget {
  const MembershipRequestsInfoCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F1FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 22,
            color: Color(0xFF252334),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sobre as solicitações',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF252334),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Aprove, solicite correções ou recuse as solicitações de entrada na sua turma. O aluno será notificado sobre sua decisão.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Color(0xFF6B6877),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}