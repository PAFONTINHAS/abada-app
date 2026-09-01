import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/current_belt_card_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/personal_info_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/profile_header_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/quick_actions_section_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/tusca_seal_card_widget.dart';

/// RF04 - Gerenciar Perfil
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
 
  static const String _mockUserName = 'Saci João da Silva';
  static const String _mockRoleLabel = 'Professor(a)';
  static const String _mockEmail = 'joao.silva@abadacapoeira.com';
  static const String _mockPhoneNumber = '(41) 99999-9999';
  static const String _mockCurrentBeltName = 'Corda Amarela';
  static const String _mockTuscaStatusLabel = 'REGULAR';
  static const String _mockTuscaExpirationDate = '07/05/2028';
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileHeaderWidget(
              userName: _mockUserName,
              roleLabel: _mockRoleLabel,
            ),
            const SizedBox(height: 20),
            const PersonalInfoCard(
              fullName: _mockUserName,
              email: _mockEmail,
              phoneNumber: _mockPhoneNumber,
            ),
            const SizedBox(height: 16),
            CurrentBeltCardWidget(
              currentBeltName: _mockCurrentBeltName,
              onViewHistory: () {
                // TODO: histórico de graduação (RF03)
              },
            ),
            const SizedBox(height: 16),
            TuscaSealCardWidget(
              statusLabel: _mockTuscaStatusLabel,
              expirationDate: _mockTuscaExpirationDate,
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
 
  AppBar _buildAppBar() {
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
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: Icon(Icons.settings_outlined, color: Colors.black54),
        ),
      ],
    );
  }
}

