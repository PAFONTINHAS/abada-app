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
  final DateTime requestDate;
  final DateTime? decisionDate;

  const ProfileChangeRequestEntity({
    required this.id,
    required this.status,
    required this.userId,
    required this.userName,
    required this.requestDate,
    required this.originalBelt,
    required this.originalNickname,

    this.newBelt,
    this.newNickname,
    this.decisionDate,
  });

  bool get isPending => status == ProfileChangeRequestStatus.pending;
  bool get isApproved => status == ProfileChangeRequestStatus.approved;
  bool get isRejected => status == ProfileChangeRequestStatus.rejected;

  ProfileChangeRequestEntity copyWith({
   String? id,
   String? userId,
   String? userName,
   String? originalBelt,
   String? originalNickname,
   String?  newBelt,
   String?  newNickname,
   ProfileChangeRequestStatus? status,
   DateTime?  requestDate,
   DateTime?  decisionDate,
  }){
    
    return ProfileChangeRequestEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      originalBelt: originalBelt ?? this.originalBelt,
      originalNickname: originalNickname ?? this.originalNickname,
      status: status ?? this.status,
      newBelt: newBelt ?? this.newBelt,
      newNickname: newNickname ?? this.newNickname,
      requestDate: requestDate ?? this.requestDate,
      decisionDate: decisionDate ?? this.decisionDate,
    );
  }
}
