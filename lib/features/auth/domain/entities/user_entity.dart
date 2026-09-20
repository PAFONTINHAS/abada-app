import 'package:firebase_auth/firebase_auth.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_registration_params.dart';

class UserEntity {
  UserEntity({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.belt,
    required this.nickname,
    required this.professor,
    this.userRole = 'unvalidatedUser',
    this.attendedClassess = const [],
    this.lecturedClasses = const [],
    this.isActive = true
  }); 

  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final String nickname;
  final String belt;
  final String professor;
  final String userRole;
  List<String> attendedClassess;
  List<String> lecturedClasses;

  final bool isActive;

  factory UserEntity.fromRegisterParams(
    UserCredential userCredential,
    UserRegistrationParams userRegistrationParams,
  ) {
    return UserEntity(
      uid: userCredential.user!.uid,
      fullName: userRegistrationParams.fullName,
      email: userRegistrationParams.email,
      phone: userRegistrationParams.phone,
      belt: userRegistrationParams.belt,
      nickname: userRegistrationParams.nickname,
      professor: userRegistrationParams.professor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email.trim(),
      'phone': phone.trim(),
      'belt': belt.trim(),
      'fullName': fullName.trim(),
      'nickname': nickname.trim(),
      'professor': professor.trim(),
      'userRole': userRole.trim(),
      'lecturedClasses': lecturedClasses,
      'attendedClasses': attendedClassess,
      'isActive': isActive,
    };
  }
}
