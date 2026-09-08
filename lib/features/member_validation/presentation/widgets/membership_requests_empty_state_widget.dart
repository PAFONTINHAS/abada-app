import 'package:flutter/material.dart';

class MembershipRequestsEmptyStateWidget extends StatelessWidget {
  const MembershipRequestsEmptyStateWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 48,
        horizontal: 20,
      ),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          const Text(
            'Nenhuma solicitação pendente.',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B6877),
            ),
          ),
        ],
      ),
    );
  }
}