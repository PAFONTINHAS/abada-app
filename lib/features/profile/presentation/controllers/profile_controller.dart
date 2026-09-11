import 'package:flutter/foundation.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/usecases/logout_user_usecase.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/usecases/update_info_usecase.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/usecases/upload_profile_photo_usecase.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/usecases/get_current_user_profile_usecase.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/usecases/request_belt_nickname_change_usecase.dart';

enum ProfileLoadStatus { loading, loaded, error }

class ProfileController extends ChangeNotifier {
  final UpdateProfileInfoUseCase _updateProfileInfoUseCase;
  final UploadProfilePhotoUsecase _uploadProfilePhotoUsecase;
  final GetCurrentUserProfileUsecase _getCurrentUserProfileUsecase;
  final RequestBeltNicknameChangeUseCase _requestBeltNicknameChangeUseCase;

  ProfileController(
    this._getCurrentUserProfileUsecase,
    this._updateProfileInfoUseCase,
    this._uploadProfilePhotoUsecase,
    this._requestBeltNicknameChangeUseCase,
  ) {
    loadProfile();
  }

  ProfileLoadStatus status = ProfileLoadStatus.loading;
  UserProfileEntity? profile;
  String? errorMessage;

  Future<void> loadProfile() async {
    status = ProfileLoadStatus.loading;
    notifyListeners();

    final result = await _getCurrentUserProfileUsecase.call();

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
    final result = await _uploadProfilePhotoUsecase.call(imageBytes);
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
