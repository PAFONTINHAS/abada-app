import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/entities/user_profile_entity.dart';
import '../../domain/entities/profile_change_request_entity.dart';
import '../models/profile_change_request_model.dart';
import '../../domain/repository/profile_repository.dart';
import '../datasources/user_profile_firestore_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final UserProfileFirestoreDataSource dataSource;

  ProfileRepositoryImpl(this.dataSource);

  @override
  Future<UserProfileEntity> searchProfile(String userId) async {
    return await dataSource.fetchProfile(userId);
  }

  @override
  Future<void> updateInfo(
    String userId, {
    String? email,
    String? phoneNumber,
  }) async {
    final updatedData = <String, dynamic>{};
    if (email != null) updatedData['email'] = email;
    if (phoneNumber != null) updatedData['phoneNumber'] = phoneNumber;

    await dataSource.updateDirectFields(userId, updatedData);
  }

  @override
  Future<void> requestChangeBeltNick({
    required String originalBelt,
    required String originalNickname,
    String? newBelt,
    String? newNickname,
  }) async {
    final userId = _currentUserId;
    if (await dataSource.hasPendingChangeRequest(userId)) {
      throw Exception('Já existe uma solicitação pendente para este perfil.');
    }
    final profile = await getCurrentUserProfile();
    final requestData = <String, dynamic>{
      'userName': profile.displayName,
      'originalBelt': originalBelt,
      'originalNickname': originalNickname,
    };
    if (newBelt != null) requestData['newBelt'] = newBelt;
    if (newNickname != null) requestData['newNickname'] = newNickname;

    await dataSource.createChangeRequest(userId, requestData);
  }

  @override
  Future<UserProfileEntity> getCurrentUserProfile() async {
    return searchProfile(_currentUserId);
  }

  @override
  Future<void> updatePersonalInfo({
    required String fullName,
    required String email,
    required String phoneNumber,
  }) async {
    final updatedData = <String, dynamic>{
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
    };

    await dataSource.updateDirectFields(_currentUserId, updatedData);
  }

  @override
  Future<void> uploadProfilePhoto(Uint8List imageBytes) async {
    final userId = _currentUserId;
    final photoReference = FirebaseStorage.instance.ref(
      'users/$userId/profile.jpg',
    );
    await photoReference.putData(
      imageBytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    final photoUrl = await photoReference.getDownloadURL();
    await dataSource.updateDirectFields(userId, {'photoUrl': photoUrl});
  }

  @override
  Future<List<ProfileChangeRequestEntity>> getMyChangeRequests() {
    return dataSource.fetchChangeRequests(
      userId: _currentUserId,
      pendingOnly: false,
    );
  }

  @override
  Future<List<ProfileChangeRequestEntity>> getPendingChangeRequests() {
    return dataSource.fetchChangeRequests(userId: '', pendingOnly: true);
  }

  @override
  Future<void> decideChangeRequest({
    required ProfileChangeRequestEntity request,
    required bool approve,
  }) async {
    final model = request is ProfileChangeRequestModel
        ? request
        : ProfileChangeRequestModel(
            id: request.id,
            userId: request.userId,
            userName: request.userName,
            originalBelt: request.originalBelt,
            originalNickname: request.originalNickname,
            newBelt: request.newBelt,
            newNickname: request.newNickname,
            status: request.status,
            requestDate: request.requestDate,
            decisionDate: request.decisionDate,
          );
    final collection = await dataSource.profileCollectionFor(request.userId);
    await dataSource.decideChangeRequest(
      model,
      approve: approve,
      profileCollection: collection,
    );
  }

  String get _currentUserId {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Nenhum usuário autenticado.');
    }
    return user.uid;
  }
}
