import 'package:sistema_abada_capoeira/features/profile/domain/entities/acess_profile.dart';

enum TuscaStatus { regular, pending, exempt, notApplicable }

class UserProfileEntity {
  final String uid;
  final String nickname;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String currentBeltName;
  final UserRole role;
  final TuscaStatus tuscaStatus;
  final DateTime? tuscaExpirationDate;
  final String? photoUrl;
  final String city;
  final String state;
  final bool isActive;

  const UserProfileEntity({
    required this.uid,
    this.nickname = '',
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.currentBeltName,
    required this.role,
    required this.tuscaStatus,
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
    String? id,
    String? nickname,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? currentBeltName,
    UserRole? role,
    TuscaStatus? tuscaStatus,
    DateTime? tuscaExpirationDate,
    String? photoUrl,
    String? city,
    String? state,
    bool? isActive,
  }) {
    return UserProfileEntity(
      uid: id ?? uid,
      nickname: nickname ?? this.nickname,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      currentBeltName: currentBeltName ?? this.currentBeltName,
      role: role ?? this.role,
      tuscaStatus: tuscaStatus ?? this.tuscaStatus,
      tuscaExpirationDate: tuscaExpirationDate ?? this.tuscaExpirationDate,
      photoUrl: photoUrl ?? this.photoUrl,
      city: city ?? this.city,
      state: state ?? this.state,
      isActive: isActive ?? this.isActive,
    );
  }
}
