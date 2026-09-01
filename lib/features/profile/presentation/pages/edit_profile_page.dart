import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/validators/info_profile_validator.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/button_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/personal_info_form_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/profile_header_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/labeled_text_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';

/// Edit Perfil (RF04)
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _nicknameController;
  late final TextEditingController _beltController;
  bool _isSaving = false;
  bool _isUploadingPhoto = false;
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileController>().profile;
    _nameController = TextEditingController(text: profile?.fullName ?? '');
    _emailController = TextEditingController(text: profile?.email ?? '');
    _phoneController = TextEditingController(text: profile?.phoneNumber ?? '');
    _nicknameController = TextEditingController();
    _beltController = TextEditingController();
    _controllersInitialized = profile != null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nicknameController.dispose();
    _beltController.dispose();
    super.dispose();
  }

  Future<void> _handlePickPhoto() async {
    final profileController = context.read<ProfileController>();
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile == null) return;
    if (!mounted) return;

    setState(() => _isUploadingPhoto = true);
    bool success = false;
    try {
      final Uint8List imageBytes = await pickedFile.readAsBytes();
      success = await profileController.uploadProfilePhoto(imageBytes);
    } catch (error) {
      profileController.errorMessage = error.toString();
    }

    if (!mounted) return;
    setState(() => _isUploadingPhoto = false);

    if (!success) {
      final details = profileController.errorMessage;
      _showSnackBar(
        details == null || details.isEmpty
            ? 'Não foi possível enviar a foto.'
            : 'Falha ao enviar foto: $details',
      );
    }
  }

  Future<void> _handleSave() async {
    if (!_isFormValid()) {
      _showSnackBar('Preencha nome, e-mail e telefone corretamente.');
      return;
    }

    setState(() => _isSaving = true);
    final profile = context.read<ProfileController>().profile;
    final success = await context.read<ProfileController>().updatePersonalInfo(
      fullName: _fullNameToSave(_nameController.text, profile?.nickname ?? ''),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      Navigator.of(context).pop();
    } else {
      _showSnackBar('Não foi possível salvar as alterações.');
    }
  }

  Future<void> _handleRequestChange() async {
    final profileController = context.read<ProfileController>();
    final profile = profileController.profile;
    final newNickname = _nicknameController.text.trim();
    final newBelt = _beltController.text.trim();
    if (profile == null || (newNickname.isEmpty && newBelt.isEmpty)) {
      _showSnackBar('Informe um novo apelido ou uma nova corda.');
      return;
    }
    if (newNickname.isNotEmpty &&
        newNickname == profile.nickname &&
        newBelt.isEmpty) {
      _showSnackBar('Informe uma alteração diferente dos dados atuais.');
      return;
    }
    setState(() => _isSaving = true);
    final success = await profileController.requestBeltNicknameChange(
      originalBelt: profile.currentBeltName,
      originalNickname: profile.nickname,
      newNickname: newNickname.isEmpty ? null : newNickname,
      newBelt: newBelt.isEmpty ? null : newBelt,
    );
    if (!mounted) return;
    setState(() => _isSaving = false);
    _showSnackBar(
      success
          ? 'Solicitação enviada para análise.'
          : (profileController.errorMessage ??
                'Não foi possível enviar a solicitação.'),
    );
    if (success) {
      _nicknameController.clear();
      _beltController.clear();
    }
  }

  bool _isFormValid() {
    return InfoProfileValidator.isValidFullName(_nameController.text) &&
        InfoProfileValidator.isValidEmail(_emailController.text) &&
        InfoProfileValidator.isValidPhoneNumber(_phoneController.text);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileController>().profile;
    if (profile != null && !_controllersInitialized) {
      _nameController.text = profile.fullName;
      _emailController.text = profile.email;
      _phoneController.text = profile.phoneNumber;
      _controllersInitialized = true;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Editar perfil',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeaderWidget(
              userName: profile?.displayName ?? '',
              roleLabel: profile?.role.name ?? '',
              cityLabel: _cityLabel(profile),
              photoUrl: profile?.photoUrl ?? '',
              isEditable: true,
              avatarRadius: 48,
              isUploadingPhoto: _isUploadingPhoto,
              onChangePhoto: _handlePickPhoto,
            ),
            const SizedBox(height: 24),
            PersonalInfoForm(
              nameController: _nameController,
              emailController: _emailController,
              phoneController: _phoneController,
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
              controller: _nicknameController,
            ),
            const SizedBox(height: 14),
            LabeledTextField(
              label: 'Nova corda',
              icon: Icons.emoji_events_outlined,
              controller: _beltController,
            ),
            const SizedBox(height: 12),
            ButtonWidget(
              label: 'Solicitar alteração',
              isLoading: _isSaving,
              onPressed: _handleRequestChange,
            ),
            const SizedBox(height: 32),
            ButtonWidget(
              label: 'Salvar alterações',
              isLoading: _isSaving,
              onPressed: _handleSave,
            ),
          ],
        ),
      ),
    );
  }

  String _cityLabel(UserProfileEntity? profile) {
    if (profile == null) return '';
    final city = profile.city;
    final state = profile.state;
    if (city.isEmpty) return state;
    if (state.isEmpty) return city;
    return '$city - $state';
  }

  String _fullNameToSave(String value, String nickname) {
    final name = value.trim();
    final nicknamePrefix = nickname.trim();
    if (nicknamePrefix.isNotEmpty && name.startsWith('$nicknamePrefix ')) {
      return name.substring(nicknamePrefix.length).trim();
    }
    return name;
  }
}
