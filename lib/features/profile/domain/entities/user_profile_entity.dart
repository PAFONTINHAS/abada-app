import 'package:sistema_abada_capoeira/features/profile/domain/entities/acess_profile.dart';

enum TuscaStatus { regular, pending, exempt, notApplicable }

class UserProfileEntity {
  final String uid;
  final String nickname;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String currentBelt;
  final UserRole role;
  final TuscaStatus tuscaStatus;
  final DateTime? tuscaExpirationDate;
  final String? photoUrl;
  final String city;
  final List<String> attendedClasses;
  final List<String> lecturedClasses;
  final String state;
  final bool isActive;

  const UserProfileEntity({
    required this.uid,
    this.nickname = '',
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.currentBelt,
    required this.role,
    required this.tuscaStatus,
    required this.attendedClasses,
    required this.lecturedClasses,
    this.tuscaExpirationDate,
    this.photoUrl,
    this.city = '',
    this.state = '',
    required this.isActive,
  });

  String get displayName {
    final parts = [
      nickname.trim(),
      fullName.trim(),
    ].where((part) => part.isNotEmpty).toList();
    return parts.join(' ');
  }

  UserProfileEntity copyWith({
    String? uid,
    String? nickname,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? currentBelt,
    UserRole? role,
    TuscaStatus? tuscaStatus,
    DateTime? tuscaExpirationDate,
    String? photoUrl,
    String? city,
    String? state,
    List<String>? attendedClasses,
    List<String>? lecturedClasses,
    bool? isActive,
  }) {
    return UserProfileEntity(
      uid: uid ?? this.uid,
      city: city ?? this.city,
      role: role ?? this.role,
      email: email ?? this.email,
      state: state ?? this.state,
      isActive: isActive ?? this.isActive,
      photoUrl: photoUrl ?? this.photoUrl,
      nickname: nickname ?? this.nickname,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      currentBelt: currentBelt ?? this.currentBelt,
      tuscaStatus: tuscaStatus ?? this.tuscaStatus,
      attendedClasses: attendedClasses ?? this.attendedClasses,
      lecturedClasses: lecturedClasses ?? this.lecturedClasses,
      tuscaExpirationDate: tuscaExpirationDate ?? this.tuscaExpirationDate,
    );
  }
}
