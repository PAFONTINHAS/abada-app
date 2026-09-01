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


/// RF04 - Gerenciar Perfil
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // ignore: unused_field
  static const String _mockUserPhoto =
      'data:image/jpeg;base64,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';

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
