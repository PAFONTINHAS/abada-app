import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile_model.dart';
import '../models/profile_change_request_model.dart';

class UserProfileFirestoreDataSource {
  final FirebaseFirestore firestore;
  UserProfileFirestoreDataSource(this.firestore);

  Future<UserProfileModel> fetchProfile(String userId) async {
    var document = await firestore.collection('users').doc(userId).get();

    if (!document.exists) {
      document = await firestore.collection('usuarios').doc(userId).get();
    }

    if (!document.exists) {
      throw Exception('User not found');
    }

    return UserProfileModel.fromMap(document.data()!, document.id);
  }

  Future<void> updateDirectFields(
    String userId,
    Map<String, dynamic> data,
  ) async {
    final usersDocument = await firestore.collection('users').doc(userId).get();
    final collection = usersDocument.exists ? 'users' : 'usuarios';
    await firestore.collection(collection).doc(userId).update(data);
  }

  Future<String> profileCollectionFor(String userId) async {
    final usersDocument = await firestore.collection('users').doc(userId).get();
    return usersDocument.exists ? 'users' : 'usuarios';
  }

  Future<void> createChangeRequest(
    String userId,
    Map<String, dynamic> data,
  ) async {
    await firestore.collection('change_requests').add({
      'userId': userId,
      'status': 'pending',
      'requestDate': FieldValue.serverTimestamp(),
      ...data,
    });
  }

  Future<bool> hasPendingChangeRequest(String userId) async {
    final snapshot = await firestore
        .collection('change_requests')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Future<List<ProfileChangeRequestModel>> fetchChangeRequests({
    required String userId,
    required bool pendingOnly,
  }) async {
    Query<Map<String, dynamic>> query = firestore.collection(
      'change_requests',
    );
    if (pendingOnly) query = query.where('status', isEqualTo: 'pending');
    if (userId.isNotEmpty) query = query.where('userId', isEqualTo: userId);
    final snapshot = await query.get();
    final requests = snapshot.docs
        .map((doc) => ProfileChangeRequestModel.fromMap(doc.id, doc.data()))
        .toList();
    requests.sort(
      (first, second) => (second.requestDate ?? DateTime(0)).compareTo(
        first.requestDate ?? DateTime(0),
      ),
    );
    return requests;
  }

  Future<void> decideChangeRequest(
    ProfileChangeRequestModel request, {
    required bool approve,
    required String profileCollection,
  }) async {
    final requestRef = firestore
        .collection('change_requests')
        .doc(request.id);
    final profileRef = firestore
        .collection(profileCollection)
        .doc(request.userId);
    await firestore.runTransaction((transaction) async {
      final requestSnapshot = await transaction.get(requestRef);
      if (!requestSnapshot.exists ||
          requestSnapshot.data()?['status'] != 'pending') {
        throw Exception('Esta solicitação já foi analisada.');
      }
      if (approve) {
        final profileSnapshot = await transaction.get(profileRef);
        if (!profileSnapshot.exists) {
          throw Exception('Perfil do aluno não encontrado.');
        }
        final updates = <String, dynamic>{};
        if (request.newBelt != null) {
          updates['currentBeltName'] = request.newBelt;
        }
        if (request.newNickname != null) {
          updates['nickname'] = request.newNickname;
        }
        transaction.update(profileRef, updates);
      }
      transaction.update(requestRef, {
        'status': approve ? 'approved' : 'rejected',
        'decisionDate': FieldValue.serverTimestamp(),
      });
    });
  }
}
