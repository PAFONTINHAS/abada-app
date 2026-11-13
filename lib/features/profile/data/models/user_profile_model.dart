// data/models/user_profile_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_profile_entity.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/extensions/user_role_extension.dart';
import 'package:sistema_abada_capoeira/features/profile/data/models/tusca_entity_model.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/acess_profile.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/tusca_entity.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.uid,
    required super.role,
    required super.tusca,
    required super.email,
    required super.fullName,
    required super.phoneNumber,
    required super.currentBelt,
    required super.attendedClasses,
    required super.lecturedClasses,
    super.city,
    super.state,
    super.nickname,
    super.photoUrl,
    super.isActive = true,
  });

  factory UserProfileModel.fromEntity(UserProfileEntity profile) {

    return UserProfileModel(
      uid: profile.uid,
      role: profile.role,
      city: profile.city,
      tusca: profile.tusca,
      email: profile.email,
      state: profile.state,
      nickname: profile.nickname,
      fullName: profile.fullName,
      isActive: profile.isActive,
      photoUrl: profile.photoUrl,
      phoneNumber: profile.phoneNumber,
      currentBelt: profile.currentBelt,
      attendedClasses: profile.attendedClasses,
      lecturedClasses: profile.lecturedClasses,
    );
  }

  factory UserProfileModel.fromSnapshot(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;

    final UserRole userRole = UserRoleExtension.getFromString(data['userRole']);
    final TuscaEntity tuscaEntity = TuscaEntityModel.fromSnapshotData(data['tusca']);

    return UserProfileModel(
      role: userRole,
      uid: document.id,
      tusca: tuscaEntity,
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'],
      nickname: data['nickname'] ?? '',
      fullName: data['fullName'] ?? '',
      city: data['city'] ?? data['cidade'] ?? '',
      phoneNumber: data['phoneNumber'] ?? data['phone'] ?? '',
      state: data['uf'] ?? data['state'] ?? data['estado'] ?? '',
      currentBelt: data['currentBeltName'] ?? data['belt'] ?? '',
      attendedClasses: List.from(data['attendedClasses'] ?? []), 
      lecturedClasses: List.from(data['lecturedClasses'] ?? []),
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {

    return {
      'nickname': nickname,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'currentBeltName': currentBelt,
      'role': role.name,
      'photoUrl': photoUrl,
      'tusca': tusca.toMap(),
      'city': city,
      'attendedClasses': attendedClasses,
      'lecturedClasses': lecturedClasses,
      'uf': state,
      'isActive': isActive,
    };
  }

}
