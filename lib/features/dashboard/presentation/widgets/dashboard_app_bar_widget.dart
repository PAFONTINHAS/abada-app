import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/extensions/user_role_extension.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';

class DashboardAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationTap;

  const DashboardAppBarWidget({
    super.key,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {

    final profileController = context.read<ProfileController>();

    final userProfile = profileController.userProfile;

    final userRole = UserRoleExtension.convertToUIText(userProfile.role);
    final userProfilePicture = userProfile.photoUrl;

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
      titleSpacing: 16,
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF1F18AB).withValues(alpha: 0.1),
            backgroundImage: userProfilePicture != null ? NetworkImage(userProfilePicture) : null,
            child: userProfilePicture == null
                ? const Icon(Icons.person, color: Color(0xFF1F18AB))
                : null,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olá, ${userProfile.nickname}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                '$userRole • Corda ${userProfile.currentBelt}',
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