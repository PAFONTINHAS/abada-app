import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_role.dart';

class UserRoleExtension {

  UserRoleExtension._();

  static UserRole getFromString(String role){
    switch (role){
      case 'unvalidatedUser': return UserRole.unvalidatedUser;
      case 'professor': return UserRole.professor;
      case 'student': return UserRole.student;
      case 'coordenator': return UserRole.coordenator;
      default: return UserRole.unknown;
    }
  }

}