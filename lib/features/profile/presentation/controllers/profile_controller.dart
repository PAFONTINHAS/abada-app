import 'package:flutter/foundation.dart';
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
  );

  ProfileLoadStatus status = ProfileLoadStatus.loading;

  late UserProfileEntity _userProfile;
  UserProfileEntity get userProfile => _userProfile;

  String? errorMessage;

  Future<void> getUserProfile(String userId) async {
    status = ProfileLoadStatus.loading;
    notifyListeners();

    final result = await _getCurrentUserProfileUsecase.call(userId);

    result.fold(
      (failure) {
        errorMessage = failure.message;
        status = ProfileLoadStatus.error;
        return false;
      },
      (loadedProfile) {
        _userProfile = loadedProfile;
        status = ProfileLoadStatus.loaded;
        return true;
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
      userProfileEntity: _userProfile,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
    );

    final success = result.fold(
      (failure) {
        errorMessage = failure.message;
        return false;
      },
      (updatedUser){
        
        _userProfile = updatedUser;
        return true;
      },
    );

    notifyListeners();

    return success;
  }


  Future<bool> requestBeltNicknameChange({
    required String originalBelt,
    required String originalNickname,
    String? newBelt,
    String? newNickname,
  }) async {
    
    final result = await _requestBeltNicknameChangeUseCase.execute(
      userProfile: _userProfile,
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
    
    final result = await _uploadProfilePhotoUsecase.call(_userProfile, imageBytes);

    final success = result.fold((failure) {
      errorMessage = failure.message;
      return false;
    }, (updatedUser){

      _userProfile = updatedUser;

      return true;
    });

    notifyListeners();

    return success;
  }
}
