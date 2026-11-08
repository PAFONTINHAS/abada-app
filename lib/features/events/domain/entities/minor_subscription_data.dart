class MinorStudentSubscriptionData {

  final String legalGuardian;
  final String studentCurrentBelt;
  final String legalGuardianPhoneNumber;
  final bool   hasLegalGuardianConsent;

  const MinorStudentSubscriptionData({
    required this.legalGuardian,
    required this.studentCurrentBelt,
    required this.legalGuardianPhoneNumber,
    required this.hasLegalGuardianConsent,
  });

  Map<String, dynamic> toMap() {
    return {
      'legalGuardian': legalGuardian,
      'studentCurrentBelt': studentCurrentBelt,
      'legalGuardianPhoneNumber': legalGuardianPhoneNumber,
      'hasLegalGuardianConsent': hasLegalGuardianConsent,
    };
  }


}