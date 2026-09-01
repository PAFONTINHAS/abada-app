import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/repository/profile_repository.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/usecases/request_change_info.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/usecases/update_info_usecase.dart';

enum ProfileLoadStatus { loading, loaded, error }

class ProfileController extends ChangeNotifier {
  final ProfileRepository _repository;
  final UpdateProfileInfoUseCase _updateProfileInfoUseCase;
  final RequestBeltNicknameChangeUseCase _requestBeltNicknameChangeUseCase;

  ProfileController(this._repository)
    : _updateProfileInfoUseCase = UpdateProfileInfoUseCase(_repository),
      _requestBeltNicknameChangeUseCase = RequestBeltNicknameChangeUseCase(
        _repository,
      ) {
    loadProfile();
  }

  ProfileLoadStatus status = ProfileLoadStatus.loading;
  UserProfileEntity? profile;
  String? errorMessage;

  Future<void> loadProfile() async {
    status = ProfileLoadStatus.loading;
    notifyListeners();

    try {
      profile = await _repository.getCurrentUserProfile();
      status = ProfileLoadStatus.loaded;
    } catch (error) {
      errorMessage = error.toString();
      status = ProfileLoadStatus.error;
    }

    notifyListeners();
  }

  Future<bool> updatePersonalInfo({
    required String fullName,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      await _updateProfileInfoUseCase.execute(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
      );
      await loadProfile();
      return true;
    } catch (error) {
      errorMessage = error.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> requestBeltNicknameChange({
    required String originalBelt,
    required String originalNickname,
    String? newBelt,
    String? newNickname,
  }) async {
    try {
      await _requestBeltNicknameChangeUseCase.execute(
        originalBelt: originalBelt,
        originalNickname: originalNickname,
        newBelt: newBelt,
        newNickname: newNickname,
      );
      return true;
    } catch (error) {
      errorMessage = error.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> uploadProfilePhoto(Uint8List imageBytes) async {
    try {
      await _repository.uploadProfilePhoto(imageBytes);
      await loadProfile();
      return true;
    } catch (error) {
      errorMessage = error.toString();
      notifyListeners();
      return false;
    }
  }
}
