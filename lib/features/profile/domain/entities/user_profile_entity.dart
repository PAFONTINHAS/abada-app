enum AccessProfile {
  user,
  student,
  graduatedStudent,
  teacher,
  coordinator,
  tuscaVolunteer,
}

enum TuscaStatus { regular, pending, exempt, notApplicable }

class UserProfileEntity {
  final String id;
  final String nickname;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String currentBeltName;
  final AccessProfile role;
  final TuscaStatus tuscaStatus;
  final DateTime? tuscaExpirationDate;
  final String? photoUrl;
  final String city;
  final String state;

  const UserProfileEntity({
    required this.id,
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
  });

  String get displayName {
    final parts = [
      nickname.trim(),
      fullName.trim(),
    ].where((part) => part.isNotEmpty).toList();
    return parts.join(' ');
  }
}
