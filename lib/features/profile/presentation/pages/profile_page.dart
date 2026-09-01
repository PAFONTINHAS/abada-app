import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/current_belt_card_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/personal_info_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/profile_header_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/quick_actions_section_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/tusca_seal_card_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/change_request_status_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/button_widget.dart';

/// RF04 - Gerenciar Perfil
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileController>();
    final profile = controller.profile;

    if (controller.status == ProfileLoadStatus.loading && profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (profile == null) {
      return Scaffold(
        body: Center(
          child: Text(controller.errorMessage ?? 'Perfil não encontrado.'),
        ),
      );
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
              roleLabel: _roleLabel(profile.role),
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
              currentBeltName: profile.currentBeltName,
              onViewHistory: () {
                // TODO: histórico de graduação (RF03)
              },
            ),
            const SizedBox(height: 16),
            TuscaSealCardWidget(
              statusLabel: _tuscaStatusLabel(profile.tuscaStatus),
              expirationDate: _formatDate(profile.tuscaExpirationDate),
              onDownloadReceipt: () {
                // TODO: Download comprovante de regularidade TUSCA (RF15)
              },
            ),
            const SizedBox(height: 20),
            QuickActionsSectionWidget(
              onRequestExemption: () {
                // TODO: Navegar para Solicitar isencao (RF12)
              },
              onPayFee: () {
                // TODO: Navegar para Pagar taxa (RF14)
              },
            ),
            const SizedBox(height: 24),
            ButtonWidget(
              label: 'Sair da Conta',
              isLoading: false,
              icon: Icons.logout,
              backgroundColor: Colors.red,
              onPressed: () {
                // TODO: Implementar logout
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

  String _roleLabel(AccessProfile role) {
    const labels = {
      AccessProfile.user: 'Usuário',
      AccessProfile.student: 'Aluno(a)',
      AccessProfile.graduatedStudent: 'Aluno(a) graduado(a)',
      AccessProfile.teacher: 'Professor(a)',
      AccessProfile.coordinator: 'Coordenador(a)',
      AccessProfile.tuscaVolunteer: 'Voluntário(a) TUSCA',
    };
    return labels[role] ?? 'Usuário';
  }

  String _tuscaStatusLabel(TuscaStatus status) {
    const labels = {
      TuscaStatus.regular: 'REGULAR',
      TuscaStatus.pending: 'PENDENTE',
      TuscaStatus.exempt: 'ISENTO',
      TuscaStatus.notApplicable: 'NÃO APLICÁVEL',
    };
    return labels[status] ?? 'NÃO APLICÁVEL';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
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
      actions: [
        IconButton(
          padding: const EdgeInsets.only(right: 16),
          icon: const Icon(Icons.settings_outlined, color: Colors.black54),
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const EditProfilePage()));
          },
        ),
      ],
    );
  }
}
