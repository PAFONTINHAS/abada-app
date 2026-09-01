import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/profile_change_request_entity.dart';

class ProfileChangeRequestModel extends ProfileChangeRequestEntity {
  const ProfileChangeRequestModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.originalBelt,
    required super.originalNickname,
    super.newBelt,
    super.newNickname,
    required super.status,
    super.requestDate,
    super.decisionDate,
  });

  factory ProfileChangeRequestModel.fromMap(String id, Map<String, dynamic> map) {
    final requestDate = map['requestDate'];
    final decisionDate = map['decisionDate'];

    return ProfileChangeRequestModel(
      id: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      originalBelt: map['originalBelt'] ?? '',
      originalNickname: map['originalNickname'] ?? '',
      newBelt: map['newBelt'],
      newNickname: map['newNickname'],
      status: map['status'] ?? 'pending',
      requestDate: requestDate is Timestamp ? requestDate.toDate() : null,
      decisionDate: decisionDate is Timestamp ? decisionDate.toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'originalBelt': originalBelt,
      'originalNickname': originalNickname,
      if (newBelt != null) 'newBelt': newBelt,
      if (newNickname != null) 'newNickname': newNickname,
      'status': status,
      if (requestDate != null) 'requestDate': Timestamp.fromDate(requestDate!),
      if (decisionDate != null) 'decisionDate': Timestamp.fromDate(decisionDate!),
    };
  }
}
