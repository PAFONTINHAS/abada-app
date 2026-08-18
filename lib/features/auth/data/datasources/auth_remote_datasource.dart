import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_entity.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_credential_params.dart';

abstract class AuthRemoteDatasource {

  Future<Either<Failure, UserEntity>> registerUser(UserEntity userRegistrationParams);
  Future<Either<Failure, UserCredential>> createUserCredential(UserCredentialParams userCredentialParams);

}