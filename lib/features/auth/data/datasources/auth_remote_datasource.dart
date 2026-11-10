import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_registration_entity.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_credential_params.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_login_params.dart';

abstract class AuthRemoteDatasource {
  Future<Either<Failure, void>> logoutUser();
  Future<Either<Failure, void>> deleteUser(User user);
  Future<Either<Failure, UserCredential>> authenticateUser(UserLoginParams userLoginParams);
  Future<Either<Failure, UserCredential>> createUserCredential(UserCredentialParams userCredentialParams);
  Future<Either<Failure, UserRegistrationEntity>> registerUser(UserRegistrationEntity userRegistrationParams);
}
