enum UserRole {
  unknown,
  unvalidatedUser,
  student,
  graduatedStudent,
  professor,
  coordinator,
  tuscaVolunteer,
}


extension RoleExtension on UserRole{

  bool get isStudent => this == UserRole.student;
  bool get isProfessor => this == UserRole.professor;
  bool get isCoordinator => this == UserRole.coordinator;
  bool get isGraduatedStudent=> this == UserRole.graduatedStudent;
  bool get isUnvalidatedUser=> this == UserRole.unvalidatedUser;

  String get string{

    switch(this){
      case UserRole.unknown: return 'unknown';
      case UserRole.unvalidatedUser: return 'unvalidatedUser';
      case UserRole.student: return 'student';
      case UserRole.graduatedStudent: return 'graduatedStudent';
      case UserRole.professor: return 'professor';
      case UserRole.coordinator: return 'coordinator';
      case UserRole.tuscaVolunteer: return 'tuscaVolunteer';
    }
  }


}