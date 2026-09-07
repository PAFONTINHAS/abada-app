enum ProfileChangeRequestStatus { pending, approved, rejected }

class ProfileChangeRequestEntity {
  final String id;
  final String userId;
  final String userName;
  final String originalBelt;
  final String originalNickname;
  final String? newBelt;
  final String? newNickname;
  final ProfileChangeRequestStatus status;
  final DateTime? requestDate;
  final DateTime? decisionDate;

  const ProfileChangeRequestEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.originalBelt,
    required this.originalNickname,
    this.newBelt,
    this.newNickname,
    required this.status,
    this.requestDate,
    this.decisionDate,
  });

  bool get isPending => status == ProfileChangeRequestStatus.pending;
  bool get isApproved => status == ProfileChangeRequestStatus.approved;
  bool get isRejected => status == ProfileChangeRequestStatus.rejected;
}
