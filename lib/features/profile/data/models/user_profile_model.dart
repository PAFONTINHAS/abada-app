// data/models/user_profile_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/extensions/user_role_extension.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/acess_profile.dart';
import '../../domain/entities/user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.uid,
    required super.fullName,
    required super.email,
    required super.phoneNumber,
    required super.currentBelt,
    required super.role,
    required super.tuscaStatus,
    required super.attendedClasses,
    required super.lecturedClasses,
    super.nickname,
    super.tuscaExpirationDate,
    super.photoUrl,
    super.city,
    super.state,
  });

  factory UserProfileModel.fromEntity(UserProfileEntity profile) {
    return UserProfileModel(
      uid: profile.uid,
      nickname: profile.nickname,
      fullName: profile.fullName,
      email: profile.email,
      phoneNumber: profile.phoneNumber,
      currentBelt: profile.currentBelt,
      role: profile.role,
      tuscaStatus: profile.tuscaStatus,
      tuscaExpirationDate: profile.tuscaExpirationDate,
      photoUrl: profile.photoUrl,
      city: profile.city,
      state: profile.state,
      attendedClasses: profile.attendedClasses,
      lecturedClasses: profile.lecturedClasses
    );
  }

  factory UserProfileModel.fromSnapshot(DocumentSnapshot document) {


    final data = document.data() as Map<String, dynamic>;

    final UserRole userRole = UserRoleExtension.getFromString(data['userRole']);

    return UserProfileModel(
      uid: document.id,
      nickname: data['nickname'] ?? '',
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? data['phone'] ?? '',
      currentBelt: data['currentBeltName'] ?? data['belt'] ?? '',
      role: userRole,
      tuscaStatus: _tuscaStatusFromString(data['tuscaStatus']),
      tuscaExpirationDate: (data['tuscaExpirationDate'] as Timestamp?)?.toDate(),
      photoUrl: data['photoUrl'],
      city: data['city'] ?? data['cidade'] ?? '',
      state: data['uf'] ?? data['state'] ?? data['estado'] ?? '',
      attendedClasses: List.from(data['attendedClasses'] ?? []), 
      lecturedClasses: List.from(data['lecturedClasses'] ?? []) 
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
      'currentBeltName': currentBelt,
      'role': role.name,
      'tuscaStatus': tuscaStatus.name,
      'tuscaExpirationDate': expirationDate  ,
      'photoUrl': photoUrl,
      'city': city,
      'attendedClasses': attendedClasses,
      'lecturedClasses': lecturedClasses,
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
