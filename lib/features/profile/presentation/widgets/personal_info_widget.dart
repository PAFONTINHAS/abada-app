import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/info_card_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/info_row_widget.dart';

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
    return InfoCardWidget(
      children: [
        InfoRowWidget(
          icon: Icons.person_outline,
          label: 'Nome Completo',
          value: fullName,
        ),
        const Divider(height: 24),
        InfoRowWidget(
          icon: Icons.email_outlined,
          label: 'Email',
          value: email,
        ),
        const Divider(height: 24),
        InfoRowWidget(
          icon: Icons.phone_outlined,
          label: 'Telefone',
          value: phoneNumber,
        ),
      ],
    );
  }
}