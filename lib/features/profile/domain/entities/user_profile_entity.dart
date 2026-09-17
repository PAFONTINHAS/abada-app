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
    List<String>? attendedClassess,
    List<String>? lecturedClasses,
    
  }){

    return UserProfileEntity(
      uid: id ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      currentBelt: currentBeltName ?? this.currentBelt,
      role: role ?? this.role,
      tuscaStatus: tuscaStatus ?? this.tuscaStatus,
      tuscaExpirationDate: tuscaExpirationDate ?? this.tuscaExpirationDate,
      photoUrl: photoUrl ?? this.photoUrl,
      attendedClasses: attendedClassess ?? this.attendedClasses,
      lecturedClasses: lecturedClasses ?? this.lecturedClasses
    );

  }
}
