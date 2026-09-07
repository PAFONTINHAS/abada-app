import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sistema_abada_capoeira/core/errors/exception_handler.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';

import '../../domain/entities/user_profile_entity.dart';
import '../../domain/entities/profile_change_request_entity.dart';
import '../models/profile_change_request_model.dart';
import '../../domain/repository/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource dataSource;

  ProfileRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, UserProfileEntity>> searchProfile(
    String userId,
  ) async {
    try {
      final result = await dataSource.fetchProfile(userId);
      return result.fold(
        (failure) => Left(failure),
        (profile) => Right(profile),
      );
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'searchProfile',
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateUserEntity(
    UserProfileEntity profile,
  ) async {
    try {
      return await dataSource.updateUserEntity(profile);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'updateUserEntity',
      );
    }
  }

  @override
  Future<Either<Failure, void>> createChangeRequest(
    ProfileChangeRequestEntity request,
  ) async {
    try {
      final pendingResult = await dataSource.hasPendingChangeRequest(
        request.userId,
      );
      final hasPendingRequest = pendingResult.fold(
        (failure) => throw Exception(failure.message),
        (hasPending) => hasPending,
      );
      if (hasPendingRequest) {
        return const Left(
          ValidationFailure(
            'Já existe uma solicitação pendente para este perfil.',
          ),
        );
      }
      final model = request is ProfileChangeRequestModel
          ? request
          : ProfileChangeRequestModel(
              id: request.id,
              userId: request.userId,
              userName: request.userName,
              originalBelt: request.originalBelt,
              originalNickname: request.originalNickname,
              status: request.status,
              newBelt: request.newBelt,
              newNickname: request.newNickname,
              requestDate: request.requestDate,
              decisionDate: request.decisionDate,
            );
      return dataSource.createChangeRequest(model);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'createChangeRequest',
      );
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> getCurrentUserProfile() async {
    try {
      return await searchProfile(FirebaseAuth.instance.currentUser!.uid);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'getCurrentUserProfile',
      );
    }
  }

  @override
  Future<Either<Failure, void>> uploadProfilePhoto(Uint8List imageBytes) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final uploadResult = await dataSource.uploadProfilePhoto(
        userId,
        imageBytes,
      );
      final photoUrl = uploadResult.fold((failure) => null, (url) => url);
      if (photoUrl == null) {
        return uploadResult.map((_) {});
      }

      final profileResult = await getCurrentUserProfile();
      final profile = profileResult.fold(
        (failure) => throw Exception(failure.message),
        (profile) => profile,
      );
      final updateResult = await updateUserEntity(
        UserProfileEntity(
          id: profile.id,
          nickname: profile.nickname,
          fullName: profile.fullName,
          email: profile.email,
          phoneNumber: profile.phoneNumber,
          currentBeltName: profile.currentBeltName,
          role: profile.role,
          tuscaStatus: profile.tuscaStatus,
          tuscaExpirationDate: profile.tuscaExpirationDate,
          photoUrl: photoUrl,
          city: profile.city,
          state: profile.state,
        ),
      );
      return updateResult;
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'uploadProfilePhoto',
      );
    }
  }

  @override
  Future<Either<Failure, List<ProfileChangeRequestEntity>>>
  getMyChangeRequests() async {
    try {
      final result = await dataSource.fetchChangeRequests(
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
      final collection = await dataSource.profileCollectionFor(request.userId);
      return await dataSource.updateChangeRequest(
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
