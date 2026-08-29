import 'package:flutter/material.dart';

class DashboardAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String roleOrGraduation;
  final String? avatarUrl;
  final VoidCallback? onNotificationTap;

  const DashboardAppBarWidget({
    super.key,
    required this.name,
    required this.roleOrGraduation,
    this.avatarUrl,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
      titleSpacing: 16,
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF1F18AB).withValues(alpha: 0.1),
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null
                ? const Icon(Icons.person, color: Color(0xFF1F18AB))
                : null,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olá, $name',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                roleOrGraduation,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: onNotificationTap,
          icon: const Icon(Icons.notifications_none_outlined, color: Colors.black87),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}