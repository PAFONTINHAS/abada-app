import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/core/utils/message_handler.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/tusca_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/acess_profile.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/personal_info_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/profile_header_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/tusca_seal_card_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/current_belt_card_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/edit_profile_button_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/tusca_receipt_dialog_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/quick_actions_section_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/change_request_status_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/profile_action_button_widget.dart';

/// RF04 - Gerenciar Perfil
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileController>();
    final profile = controller.userProfile;

    if (controller.status == ProfileLoadStatus.loading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeaderWidget(
              userName: profile.displayName,
              roleLabel: profile.role.string,
              cityLabel: _cityLabel(profile),
              photoUrl: profile.photoUrl ?? '',
            ),
            const SizedBox(height: 20),
            PersonalInfoCard(
              fullName: profile.displayName,
              email: profile.email,
              phoneNumber: profile.phoneNumber,
            ),
            const SizedBox(height: 16),
            const ChangeRequestStatusWidget(),
            const SizedBox(height: 16),
            CurrentBeltCardWidget(
              currentBeltName: profile.currentBelt,
              onViewHistory: () {
                // TODO: histórico de graduação (RF03)
              },
            ),
            const SizedBox(height: 16),
            
            if(profile.tusca.isApplicableTusca)
              TuscaSealCardWidget(
                tuscaEntity: profile.tusca,
                onDownloadReceipt: () {
                  showDialog(
                    context: context,
                    builder: (context) => TuscaReceiptDialog(profile: profile),
                  );
                },
              ),

            const SizedBox(height: 20),
            QuickActionsSectionWidget(
              onRequestExemption: () {
                context.push('/fee-exemption/request');
              },
              onPayFee: () {
                // TODO: Navegar para Pagar taxa (RF14)
              },
            ),
            const SizedBox(height: 24),
            ProfileActionButtonWidget(
              label: 'Sair da Conta',
              isLoading: false,
              icon: Icons.logout,
              backgroundColor: Colors.red,
              onPressed: () async {

                final authController = context.read<AuthController>();
                final success = await authController.logoutUser();  

                if (success && context.mounted) {
                  MessageHandler.showSuccess(
                    context,
                    "Saiu da conta com sucesso!",
                  );
                }
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _cityLabel(UserProfileEntity profile) {
    if (profile.city.isEmpty) return profile.state;
    if (profile.state.isEmpty) return profile.city;
    return '${profile.city} - ${profile.state}';
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        'Meu Perfil',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: const [EditProfileButtonWidget()],
    );
  }
}
