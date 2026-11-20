class ClassProfessorEntity {

  const ClassProfessorEntity({
    required this.professorId,
    required this.professorNickname,
  });

  final String professorId;
  final String professorNickname;

  Map<String, dynamic> toMap(){
    return {

      'professorId': professorId,
      'professorNickname': professorNickname
    };
  }
}