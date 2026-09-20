import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/validators/info_profile_validator.dart';
import 'profile_controller.dart';

class ProfileFormController extends ChangeNotifier {
  final ProfileController _profileController;

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController nicknameController;
  late final TextEditingController beltController;

  bool _initialized = false;
  bool isUploadingPhoto = false;
  bool isSaving = false;
  String? errorMessage;
  String? photoErrorMessage;

  ProfileFormController(this._profileController) {
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    nicknameController = TextEditingController();
    beltController = TextEditingController();
  }

  void initialize(UserProfileEntity? profile) {
    if (_initialized || profile == null) return;

    nameController.text = profile.fullName;
    emailController.text = profile.email;
    phoneController.text = profile.phoneNumber;
    _initialized = true;
  }

  bool get isInitialized => _initialized;

  bool get isValid =>
      InfoProfileValidator.isValidFullName(nameController.text) &&
      InfoProfileValidator.isValidEmail(emailController.text) &&
      InfoProfileValidator.isValidPhoneNumber(phoneController.text);

  void clearChangeRequestFields() {
    nicknameController.clear();
    beltController.clear();
  }

  Future<bool> save() async {
    if (!isValid) {
      errorMessage = 'Preencha nome, e-mail e telefone corretamente.';
      notifyListeners();
      return false;
    }

    final profile = _profileController.userProfile;
    if (profile == null) {
      errorMessage = 'Perfil não carregado.';
      notifyListeners();
      return false;
    }

    isSaving = true;
    errorMessage = null;
    notifyListeners();
    try {
      final success = await _profileController.updatePersonalInfo(
        fullName: _fullNameToSave(nameController.text, profile.nickname),
        email: emailController.text.trim(),
        phoneNumber: phoneController.text.trim(),
      );
      if (!success) errorMessage = _profileController.errorMessage;
      return success;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> requestChange() async {
    final profile = _profileController.userProfile;
    final newNickname = nicknameController.text.trim();
    final newBelt = beltController.text.trim();
    if (profile == null) {
      errorMessage = 'Perfil não carregado.';
      notifyListeners();
      return false;
    }
    if (newNickname.isEmpty && newBelt.isEmpty) {
      errorMessage = 'Informe um novo apelido ou uma nova corda.';
      notifyListeners();
      return false;
    }
    if (newNickname.isNotEmpty &&
        newNickname == profile.nickname &&
        newBelt.isEmpty) {
      errorMessage = 'Informe uma alteração diferente dos dados atuais.';
      notifyListeners();
      return false;
    }

    isSaving = true;
    errorMessage = null;
    notifyListeners();
    try {
      final success = await _profileController.requestBeltNicknameChange(
        originalBelt: profile.currentBelt,
        originalNickname: profile.nickname,
        newNickname: newNickname.isEmpty ? null : newNickname,
        newBelt: newBelt.isEmpty ? null : newBelt,
      );
      if (!success) errorMessage = _profileController.errorMessage;
      if (success) clearChangeRequestFields();
      return success;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> pickPhoto() async {
    if (isUploadingPhoto) return false;

    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile == null) return false;

    isUploadingPhoto = true;
    photoErrorMessage = null;
    notifyListeners();

    try {
      final Uint8List imageBytes = await pickedFile.readAsBytes();
      final success = await _profileController.uploadProfilePhoto(imageBytes);
      if (!success) {
        photoErrorMessage = _profileController.errorMessage;
      }
      return success;
    } catch (error) {
      photoErrorMessage = error.toString();
      return false;
    } finally {
      isUploadingPhoto = false;
      notifyListeners();
    }
  }

  String _fullNameToSave(String value, String nickname) {
    final name = value.trim();
    final nicknamePrefix = nickname.trim();
    if (nicknamePrefix.isNotEmpty && name.startsWith('$nicknamePrefix ')) {
      return name.substring(nicknamePrefix.length).trim();
    }
    return name;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    nicknameController.dispose();
    beltController.dispose();
    super.dispose();
  }
}
