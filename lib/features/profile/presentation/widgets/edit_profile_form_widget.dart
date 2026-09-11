import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_form_controller.dart';
import 'profile_action_button_widget.dart';
import 'labeled_text_widget.dart';
import 'personal_info_form_widget.dart';

class EditProfileFormWidget extends StatelessWidget {
  final ProfileFormController controller;
  final Future<void> Function() onSave;
  final Future<void> Function() onRequestChange;

  const EditProfileFormWidget({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onRequestChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PersonalInfoForm(
          nameController: controller.nameController,
          emailController: controller.emailController,
          phoneController: controller.phoneController,
        ),
        const SizedBox(height: 24),
        const Text(
          'Solicitar alteração de apelido ou corda',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        LabeledTextField(
          label: 'Novo apelido',
          icon: Icons.badge_outlined,
          controller: controller.nicknameController,
        ),
        const SizedBox(height: 14),
        LabeledTextField(
          label: 'Nova corda',
          icon: Icons.emoji_events_outlined,
          controller: controller.beltController,
        ),
        const SizedBox(height: 12),
        Selector<ProfileFormController, bool>(
          selector: (_, controller) => controller.isSaving,
          builder: (_, isSaving, _) => ProfileActionButtonWidget(
            label: 'Solicitar alteração',
            isLoading: isSaving,
            onPressed: onRequestChange,
          ),
        ),
        const SizedBox(height: 32),
        Selector<ProfileFormController, bool>(
          selector: (_, controller) => controller.isSaving,
          builder: (_, isSaving, _) => ProfileActionButtonWidget(
            label: 'Salvar alterações',
            isLoading: isSaving,
            onPressed: onSave,
          ),
        ),
      ],
    );
  }
}
