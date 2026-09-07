import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/repository/profile_repository.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/usecases/request_belt_nickname_change_usecase.dart';
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

    final result = await _repository.getCurrentUserProfile();
    result.fold(
      (failure) {
        errorMessage = failure.message;
        status = ProfileLoadStatus.error;
      },
      (loadedProfile) {
        profile = loadedProfile;
        status = ProfileLoadStatus.loaded;
      },
    );

    notifyListeners();
  }

  Future<bool> updatePersonalInfo({
    required String fullName,
    required String email,
    required String phoneNumber,
  }) async {
    final result = await _updateProfileInfoUseCase.execute(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
    );
    return result.fold(
      (failure) {
        errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) async {
        await loadProfile();
        return true;
      },
    );
  }

  Future<bool> requestBeltNicknameChange({
    required String originalBelt,
    required String originalNickname,
    String? newBelt,
    String? newNickname,
  }) async {
    final result = await _requestBeltNicknameChangeUseCase.execute(
      originalBelt: originalBelt,
      originalNickname: originalNickname,
      newBelt: newBelt,
      newNickname: newNickname,
    );
    return result.fold((failure) {
      errorMessage = failure.message;
      notifyListeners();
      return false;
    }, (_) => true);
  }

  Future<bool> uploadProfilePhoto(Uint8List imageBytes) async {
    final result = await _repository.uploadProfilePhoto(imageBytes);
    final success = result.fold((failure) {
      errorMessage = failure.message;
      return false;
    }, (_) => true);
    if (!success) {
      notifyListeners();
      return false;
    }
    await loadProfile();
    return true;
  }
}
