import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'dart:typed_data';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/profile_change_request_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfileEntity>> fetchUserProfile(String userId);

  Future<Either<Failure, UserProfileEntity>> updateUserEntity(UserProfileEntity profile);

  Future<Either<Failure, void>> createChangeRequest(
    ProfileChangeRequestEntity request,
  );

  Future<Either<Failure, String>> uploadProfilePhoto(String userId, Uint8List imageBytes);

  Future<Either<Failure, List<ProfileChangeRequestEntity>>> getMyChangeRequests();

  Future<Either<Failure, bool>> checkPendingChangeRequests(String userId);


  Future<Either<Failure, void>> updateChangeRequest({
    required ProfileChangeRequestEntity request,
    required ProfileChangeRequestStatus status,
    required Map<String, dynamic> profileUpdates,
  });
}
