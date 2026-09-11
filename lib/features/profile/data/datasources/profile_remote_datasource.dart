import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import '../../domain/entities/profile_change_request_entity.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../models/profile_change_request_model.dart';

abstract class ProfileRemoteDatasource {
  Future<Either<Failure, UserProfileEntity>> fetchProfile(String userId);

  Future<Either<Failure, void>> updateUserEntity(UserProfileEntity profile);

  Future<Either<Failure, String>> uploadProfilePhoto(
    String userId,
    Uint8List imageBytes,
  );

  Future<String> profileCollectionFor(String userId);

  Future<Either<Failure, void>> createChangeRequest(
    ProfileChangeRequestModel request,
  );

  Future<Either<Failure, bool>> hasPendingChangeRequest(String userId);

  Future<Either<Failure, List<ProfileChangeRequestModel>>> fetchChangeRequests({
    required String userId,
    required bool pendingOnly,
  });

  Future<Either<Failure, void>> updateChangeRequest(
    ProfileChangeRequestModel request, {
    required ProfileChangeRequestStatus status,
    required Map<String, dynamic> profileUpdates,
    required String profileCollection,
  });
}
