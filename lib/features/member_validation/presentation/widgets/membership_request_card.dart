import 'package:flutter/material.dart';

import '../../domain/entities/membership_request.dart';

class MembershipRequestCard extends StatelessWidget {
  final MembershipRequest request;
  final VoidCallback onApprove;
  final VoidCallback onRequestChanges;
  final VoidCallback onReject;
  final VoidCallback? onDetails;

  const MembershipRequestCard({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onRequestChanges,
    required this.onReject,
    this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            child: Icon(Icons.person),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.memberId,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  request.status.name,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  _formatDate(request.requestedAt),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),

          _ActionButton(
            icon: Icons.check,
            iconColor: Colors.deepPurple,
            backgroundColor: Colors.deepPurple.shade50,
            onPressed: onApprove,
          ),

          const SizedBox(width: 6),

          _ActionButton(
            icon: Icons.edit_outlined,
            iconColor: Colors.orange,
            backgroundColor: Colors.orange.shade50,
            onPressed: onRequestChanges,
          ),

          const SizedBox(width: 6),

          _ActionButton(
            icon: Icons.close,
            iconColor: Colors.red,
            backgroundColor: Colors.red.shade50,
            onPressed: onReject,
          ),

          if (onDetails != null) ...[
            const SizedBox(width: 4),
            IconButton(
              onPressed: onDetails,
              icon: const Icon(
                Icons.chevron_right,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/$year\n$hour:$minute';
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: iconColor,
        ),
      ),
    );
  }
}