import 'package:firebase_auth/firebase_auth.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_registration_params.dart';

class UserEntity {

  UserEntity({

    required this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.rope,
    required this.nickname,
    required this.professor,
    this.userRole = 'unvalidatedUser'

  }); 

  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final String nickname;
  final String rope;
  final String professor;
  final String userRole;

  factory UserEntity.fromRegisterParams(UserCredential userCredential, UserRegistrationParams userRegistrationParams){

    return UserEntity(
      uid: userCredential.user!.uid,
      fullName: userRegistrationParams.fullName,
      email: userRegistrationParams.email,
      phone: userRegistrationParams.phone,
      rope: userRegistrationParams.rope,
      nickname: userRegistrationParams.nickname,
      professor: userRegistrationParams.professor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'phone': phone,
      'rope': rope,
      'fullName': fullName,
      'nickname': nickname,
      'professor': professor,
      'userRole': userRole
    };
  }



}