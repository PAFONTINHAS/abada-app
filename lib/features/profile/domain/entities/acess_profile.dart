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