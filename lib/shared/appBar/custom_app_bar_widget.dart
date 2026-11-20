import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/extensions/user_role_extension.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
// Lembre-se de importar o seu arquivo de ColorConstants
// import 'caminho_para/color_constants.dart'; 

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String pageTitle;
  final VoidCallback? onNotificationTap;

  const CustomAppBarWidget({
    super.key,
    required this.pageTitle,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final profileController = context.read<ProfileController>();
    final userProfile = profileController.userProfile;
    
    final userRole = UserRoleExtension.convertToUIText(userProfile.role);

    return AppBar(
      // automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: ColorConstants.whiteColor,
      scrolledUnderElevation: 0,
      titleSpacing: 16,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nome da Página
          Text(
            pageTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorConstants.textPrimary,
            ),
          ),
          // Subtítulo com os dados do usuário (Apelido, Cargo e Corda)
          Text(
            '${userProfile.nickname} • $userRole • Corda ${userProfile.currentBelt}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: ColorConstants.textSecondary,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: onNotificationTap,
          icon: const Icon(
            Icons.notifications_none_outlined, 
            color: ColorConstants.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}