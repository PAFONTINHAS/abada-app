// data/models/user_profile_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/extensions/user_role_extension.dart';
import '../../domain/entities/user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phoneNumber,
    required super.currentBeltName,
    required super.role,
    required super.tuscaStatus,
    super.nickname,
    super.tuscaExpirationDate,
    super.photoUrl,
    super.city,
    super.state,
  });

  factory UserProfileModel.fromEntity(UserProfileEntity profile) {
    return UserProfileModel(
      id: profile.id,
      nickname: profile.nickname,
      fullName: profile.fullName,
      email: profile.email,
      phoneNumber: profile.phoneNumber,
      currentBeltName: profile.currentBeltName,
      role: profile.role,
      tuscaStatus: profile.tuscaStatus,
      tuscaExpirationDate: profile.tuscaExpirationDate,
      photoUrl: profile.photoUrl,
      city: profile.city,
      state: profile.state,
    );
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> map, String id) {
    return UserProfileModel(
      id: id,
      nickname: map['nickname'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? map['phone'] ?? '',
      currentBeltName: map['currentBeltName'] ?? map['rope'] ?? '',
      role: UserRoleExtension.getFromString(map['userRole']),
      tuscaStatus: _tuscaStatusFromString(map['tuscaStatus']),
      tuscaExpirationDate: (map['tuscaExpirationDate'] as Timestamp?)?.toDate(),
      photoUrl: map['photoUrl'],
      city: map['city'] ?? map['cidade'] ?? '',
      state: map['uf'] ?? map['state'] ?? map['estado'] ?? '',
    );
  }

  Map<String, dynamic> toMap(){

    final Timestamp? expirationDate = tuscaExpirationDate != null
          ? Timestamp.fromDate(tuscaExpirationDate!)
          : null;

    return {
      'nickname': nickname,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'currentBeltName': currentBeltName,
      'role': role.name,
      'tuscaStatus': tuscaStatus.name,
      'tuscaExpirationDate': expirationDate  ,
      'photoUrl': photoUrl,
      'city': city,
      'uf': state,
    };
  }
  
  
  

  static TuscaStatus _tuscaStatusFromString(String? value) {
    return TuscaStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TuscaStatus.notApplicable,
    );
  }
}
