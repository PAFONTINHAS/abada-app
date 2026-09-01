import 'dart:typed_data';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/profile_change_request_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';

abstract class ProfileRepository {
  Future<UserProfileEntity> searchProfile(String userId);

  Future<void> updateInfo(String userId, {String? email, String? phoneNumber});

  Future<void> requestChangeBeltNick({
    required String originalBelt,
    required String originalNickname,
    String? newBelt,
    String? newNickname,
  });

  Future<UserProfileEntity> getCurrentUserProfile();

  Future<void> updatePersonalInfo({
    required String fullName,
    required String email,
    required String phoneNumber,
  });

  Future<void> uploadProfilePhoto(Uint8List imageBytes);

  Future<List<ProfileChangeRequestEntity>> getMyChangeRequests();

  Future<List<ProfileChangeRequestEntity>> getPendingChangeRequests();

  Future<void> decideChangeRequest({
    required ProfileChangeRequestEntity request,
    required bool approve,
  });
}
