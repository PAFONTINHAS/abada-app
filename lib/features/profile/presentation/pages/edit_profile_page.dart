import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/utils/message_handler.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/edit_profile_form_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/widgets/profile_header_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_form_controller.dart';

/// Edit Perfil (RF04)
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final ProfileFormController _formController;
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    final profileController = context.read<ProfileController>();
    _formController = ProfileFormController(profileController);
    _formController.initialize(profileController.userProfile);
    _controllersInitialized = _formController.isInitialized;
  }

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  Future<void> _handlePickPhoto() async {
    final success = await _formController.pickPhoto();
    if (success || !mounted) return;

    final details = _formController.photoErrorMessage;
    MessageHandler.showError(
      context,
      details == null || details.isEmpty
          ? 'Não foi possível enviar a foto.'
          : 'Falha ao enviar foto: $details',
    );
  }

  Future<void> _handleSave() async {
    final success = await _formController.save();
    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
    } else {
      MessageHandler.showError(
        context,
        _formController.errorMessage ??
            'Não foi possível salvar as alterações.',
      );
    }
  }

  Future<void> _handleRequestChange() async {
    final success = await _formController.requestChange();
    if (!mounted) return;
    if (success) {
      MessageHandler.showSuccess(context, 'Solicitação enviada para análise.');
    } else {
      MessageHandler.showError(
        context,
        _formController.errorMessage ??
            'Não foi possível enviar a solicitação.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileController>().userProfile;
    if (profile != null && !_controllersInitialized) {
      _formController.initialize(profile);
      _controllersInitialized = true;
    }

    return ChangeNotifierProvider.value(
      value: _formController,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Editar perfil',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Selector<ProfileFormController, bool>(
                selector: (_, controller) => controller.isUploadingPhoto,
                builder: (_, isUploadingPhoto, _) => ProfileHeaderWidget(
                  userName: profile?.displayName ?? '',
                  roleLabel: profile?.role.name ?? '',
                  cityLabel: _cityLabel(profile),
                  photoUrl: profile?.photoUrl ?? '',
                  isEditable: true,
                  avatarRadius: 48,
                  isUploadingPhoto: isUploadingPhoto,
                  onChangePhoto: _handlePickPhoto,
                ),
              ),
              const SizedBox(height: 24),
              EditProfileFormWidget(
                controller: _formController,
                onSave: _handleSave,
                onRequestChange: _handleRequestChange,
              ),
            ],
          ),
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
}
