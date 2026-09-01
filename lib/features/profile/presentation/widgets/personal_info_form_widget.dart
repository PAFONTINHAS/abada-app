import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/labeled_text_widget.dart';

const Color _primaryPurple = Color(0xFF7C5CBF);

/// titulo + 3 campos para editar diretamente
class PersonalInfoForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  const PersonalInfoForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informações pessoais',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: _primaryPurple,
          ),
        ),
        const SizedBox(height: 4),
        Container(width: 142, height: 1.5, color: _primaryPurple),
        const SizedBox(height: 16),
        LabeledTextField(
          label: 'Nome completo',
          icon: Icons.person_outline,
          controller: nameController,
        ),
        const SizedBox(height: 14),
        LabeledTextField(
          label: 'E-mail',
          icon: Icons.email_outlined,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        LabeledTextField(
          label: 'Telefone',
          icon: Icons.phone_outlined,
          controller: phoneController,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }
}
