import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'profile_remote_datasource.dart';
import '../models/user_profile_model.dart';
import '../models/profile_change_request_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_profile_entity.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import '../../domain/entities/profile_change_request_entity.dart';
import 'package:sistema_abada_capoeira/core/errors/exception_handler.dart';

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, UserProfileEntity>> fetchProfile(String userId) async {
    try {
      final document = await firestore.collection('users').doc(userId).get();

      if (!document.exists) {
        throw Exception('User not found');
      }

      return Right(UserProfileModel.fromMap(document.data()!, document.id));
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'fetchProfile',
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateUserEntity(
    UserProfileEntity profile,
  ) async {
    try {
      final usersDocument = await firestore
          .collection('users')
          .doc(profile.id)
          .get();
      final collection = usersDocument.exists ? 'users' : 'usuarios';
      final profileModel = UserProfileModel.fromEntity(profile);
      await firestore
          .collection(collection)
          .doc(profile.id)
          .update(profileModel.toMap());
      return Right(null);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'updateUserEntity',
      );
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePhoto(
    String userId,
    Uint8List imageBytes,
  ) async {
    try {
      final photoReference = FirebaseStorage.instance.ref(
        'users/$userId/profile.jpg',
      );
      await photoReference.putData(
        imageBytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      return Right(await photoReference.getDownloadURL());
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'uploadProfilePhoto',
      );
    }
  }

  @override
  Future<String> profileCollectionFor(String userId) async {
    final usersDocument = await firestore.collection('users').doc(userId).get();
    return usersDocument.exists ? 'users' : 'usuarios';
  }

  @override
  Future<Either<Failure, void>> createChangeRequest(
    ProfileChangeRequestModel request,
  ) async {
    try {
      await firestore.collection('change_requests').add({
        ...request.toMap(),
        'requestDate': FieldValue.serverTimestamp(),
      });
      return Right(null);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'createChangeRequest',
      );
    }
  }

  @override
  Future<Either<Failure, bool>> hasPendingChangeRequest(String userId) async {
    try {
      final snapshot = await firestore
          .collection('change_requests')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'pending')
          .limit(1)
          .get();
      return Right(snapshot.docs.isNotEmpty);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'hasPendingChangeRequest',
      );
    }
  }

  @override
  Future<Either<Failure, List<ProfileChangeRequestModel>>> fetchChangeRequests({
    required String userId,
    required bool pendingOnly,
  }) async {
    try {
      Query<Map<String, dynamic>> query = firestore.collection('change_requests');

      if (pendingOnly) query = query.where('status', isEqualTo: 'pending');
      if (userId.isNotEmpty) query = query.where('userId', isEqualTo: userId);

      final snapshot = await query.get();

      final requests = snapshot.docs
          .map((doc) => ProfileChangeRequestModel.fromMap(doc.id, doc.data()))
          .toList();
      
      return Right(requests);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'fetchChangeRequests',
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateChangeRequest(
    ProfileChangeRequestModel request, {
    required ProfileChangeRequestStatus status,
    required Map<String, dynamic> profileUpdates,
    required String profileCollection,
  }) async {
    try {
      final requestRef = _changeRequestReference(request.id);
      final profileRef = firestore
          .collection(profileCollection)
          .doc(request.userId);
      await firestore.runTransaction((transaction) async {
        final requestSnapshot = await transaction.get(requestRef);
        if (!requestSnapshot.exists) {
          throw Exception('Solicitação não encontrada.');
        }
        if (requestSnapshot.data()?['status'] != 'pending') {
          throw Exception('Esta solicitação já foi analisada.');
        }
        if (status == ProfileChangeRequestStatus.approved) {
          final profileSnapshot = await transaction.get(profileRef);
          if (!profileSnapshot.exists) {
            throw Exception('Perfil do aluno não encontrado.');
          }
          transaction.update(profileRef, profileUpdates);
        }
        transaction.update(requestRef, {
          'status': status.name,
          'decisionDate': FieldValue.serverTimestamp(),
        });
      });
      return Right(null);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'updateChangeRequest',
      );
    }
  }

  DocumentReference<Map<String, dynamic>> _changeRequestReference(
    String requestId,
  ) {
    return firestore.collection('change_requests').doc(requestId);
  }
}
