class MinorStudentSubscriptionEntity {

  final String legalGuardianName;
  final String studentFullName;
  final String studentNickname;
  final String studentCurrentBelt;
  final String legalGuardianPhoneNumber;
  final bool   hasLegalGuardianConsent;

  const MinorStudentSubscriptionEntity({
    required this.studentFullName,
    required this.studentNickname,
    required this.studentCurrentBelt,

    required this.legalGuardianName,
    required this.legalGuardianPhoneNumber,
    required this.hasLegalGuardianConsent,
  });

  Map<String, dynamic> toMap() {
    return {
      'studentFullName': studentFullName,
      'studentNickname': studentNickname,
      'legalGuardian': legalGuardianName,
      'studentCurrentBelt': studentCurrentBelt,
      'legalGuardianPhoneNumber': legalGuardianPhoneNumber,
      'hasLegalGuardianConsent': hasLegalGuardianConsent,
    };
  }


}