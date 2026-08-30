enum UserRole {
  unknown,
  unvalidatedUser,
  student,
  professor,
  coordenator,
}

extension RoleExtension on UserRole{

  String get string {

    switch(this){
      case UserRole.coordenator: return 'coordenator';
      case UserRole.professor: return 'professor';
      case UserRole.student: return 'student';
      case UserRole.unknown: return 'unknown';
      case UserRole.unvalidatedUser: return 'unvalidatedUser';
    }
  }



}