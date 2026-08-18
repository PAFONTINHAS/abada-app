import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_entity.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_credential_params.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_login_params.dart';

abstract class AuthRepository {

  Future<Either<Failure, UserEntity>> registerUser(UserEntity user);
  Future<Either<Failure, UserEntity>> getUserDataByUserId(String userId);
  Future<Either<Failure, UserCredential>> authenticateUser(UserLoginParams userLoginParams); 
  Future<Either<Failure, UserCredential>> createUserCredential(UserCredentialParams userCredentialParams);


}