import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/profile_change_request_model.dart';
import '../datasources/profile_remote_datasource.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repository/profile_repository.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import '../../domain/entities/profile_change_request_entity.dart';
import 'package:sistema_abada_capoeira/core/errors/exception_handler.dart';


class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource profileRemoteDatasource;

  ProfileRepositoryImpl(this.profileRemoteDatasource);

  @override
  Future<Either<Failure, UserProfileEntity>> fetchUserProfile(String userId) async {

    return await profileRemoteDatasource.fetchUserProfile(userId);
  }

  @override
  Future<Either<Failure, UserProfileEntity>> updateUserEntity(UserProfileEntity profile) async {

    return await profileRemoteDatasource.updateUserEntity(profile);
  }

  @override 
  Future<Either<Failure, bool>> checkPendingChangeRequests(String userId) async{

    return await profileRemoteDatasource.hasPendingChangeRequest(userId);

  }

  @override
  Future<Either<Failure, void>> createChangeRequest(ProfileChangeRequestEntity request) async {

    return await profileRemoteDatasource.createChangeRequest(request);
  }

  @override
  Future<Either<Failure, String>> uploadProfilePhoto(String userId, Uint8List imageBytes) async {

    return await profileRemoteDatasource.uploadProfilePhoto(userId, imageBytes);
  }

  @override
  Future<Either<Failure, List<ProfileChangeRequestEntity>>> getMyChangeRequests() async {

    try {
      final result = await profileRemoteDatasource.fetchChangeRequests(
        userId: FirebaseAuth.instance.currentUser!.uid,
        pendingOnly: false,
      );
      return result.fold(
        (failure) => Left(failure),
        (requests) => Right(requests),
      );
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'getMyChangeRequests',
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateChangeRequest({
    required ProfileChangeRequestEntity request,
    required ProfileChangeRequestStatus status,
    required Map<String, dynamic> profileUpdates,
  }) async {
    try {
      final model = ProfileChangeRequestModel.fromEntity(request);
      final collection = await profileRemoteDatasource.profileCollectionFor(request.userId);
      return await profileRemoteDatasource.updateChangeRequest(
        model,
        status: status,
        profileUpdates: profileUpdates,
        profileCollection: collection,
      );
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'updateChangeRequest',
      );
    }
  }
}
