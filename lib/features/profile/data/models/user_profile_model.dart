// data/models/user_profile_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.id,
    super.nickname,
    required super.fullName,
    required super.email,
    required super.phoneNumber,
    required super.currentBeltName,
    required super.role,
    required super.tuscaStatus,
    super.tuscaExpirationDate,
    super.photoUrl,
    super.city,
    super.state,
  });

  factory UserProfileModel.fromMap(Map<String, dynamic> map, String id) {
    return UserProfileModel(
      id: id,
      nickname: map['nickname'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? map['phone'] ?? '',
      currentBeltName: map['currentBeltName'] ?? map['rope'] ?? '',
      role: _roleFromString(map['role'] ?? map['userRole']),
      tuscaStatus: _tuscaStatusFromString(map['tuscaStatus']),
      tuscaExpirationDate: (map['tuscaExpirationDate'] as Timestamp?)?.toDate(),
      photoUrl: map['photoUrl'],
      city: map['city'] ?? map['cidade'] ?? '',
      state: map['uf'] ?? map['state'] ?? map['estado'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'nickname': nickname,
    'fullName': fullName,
    'email': email,
    'phoneNumber': phoneNumber,
    'currentBeltName': currentBeltName,
    'role': role.name,
    'tuscaStatus': tuscaStatus.name,
    'tuscaExpirationDate': tuscaExpirationDate != null
        ? Timestamp.fromDate(tuscaExpirationDate!)
        : null,
    'photoUrl': photoUrl,
    'city': city,
    'uf': state,
  };

  static AccessProfile _roleFromString(String? value) {
    final normalized = value?.trim().toLowerCase();
    const aliases = {
      'usuario': AccessProfile.user,
      'usuário': AccessProfile.user,
      'aluno': AccessProfile.student,
      'aluno(a)': AccessProfile.student,
      'professor': AccessProfile.teacher,
      'professor(a)': AccessProfile.teacher,
      'coordenador': AccessProfile.coordinator,
      'coordenador(a)': AccessProfile.coordinator,
    };
    if (aliases.containsKey(normalized)) return aliases[normalized]!;

    return AccessProfile.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AccessProfile.user,
    );
  }

  static TuscaStatus _tuscaStatusFromString(String? value) {
    return TuscaStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TuscaStatus.notApplicable,
    );
  }
}
