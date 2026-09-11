import 'package:sistema_abada_capoeira/features/profile/domain/entities/acess_profile.dart';

class UserRoleExtension {

  UserRoleExtension._();

  static UserRole getFromString(String role){
    switch (role){
      case 'unvalidatedUser': return UserRole.unvalidatedUser;
      case 'professor': return UserRole.professor;
      case 'student': return UserRole.student;
      case 'coordinator': return UserRole.coordinator;
      case 'tuscaVolunteer': return UserRole.tuscaVolunteer;
      case 'graduatedStudent': return UserRole.graduatedStudent;
      default: return UserRole.unknown;
    }
  }

}