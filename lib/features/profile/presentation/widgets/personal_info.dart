import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/info_card.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/info_row.dart';

/// widget dos dados do user

class PersonalInfoCard extends StatelessWidget {
  final String fullName;
  final String email;
  final String phoneNumber;

  const PersonalInfoCard({
    super.key,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      children: [
        InfoRow(
          icon: Icons.person_outline,
          label: 'Nome Completo',
          value: fullName,
        ),
        const Divider(height: 24),
        InfoRow(
          icon: Icons.email_outlined,
          label: 'Email',
          value: email,
        ),
        const Divider(height: 24),
        InfoRow(
          icon: Icons.phone_outlined,
          label: 'Telefone',
          value: phoneNumber,
        ),
      ],
    );
  }
}