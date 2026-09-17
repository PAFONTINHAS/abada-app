class ClassMemberEntity {

  final String studentId;
  final String? name;
  final String? nickname;
  final String belt;
  final bool displaySensitiveData;

  const ClassMemberEntity({
    required this.belt,
    this.name,
    this.nickname,
    required this.studentId,
    required this.displaySensitiveData, 
  });

}