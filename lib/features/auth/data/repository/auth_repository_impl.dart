import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_entity.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/repository/auth_repository.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_credential_params.dart';
import 'package:sistema_abada_capoeira/features/auth/data/datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository{

  AuthRemoteDatasource authRemoteDatasource;

  AuthRepositoryImpl(this.authRemoteDatasource);

  @override
  Future<Either<Failure, UserEntity>> registerUser(UserEntity user) async{

    return await authRemoteDatasource.registerUser(user);

  }
  
  @override
  Future<Either<Failure, UserCredential>> createUserCredential(UserCredentialParams userCredentialParams) async{

    return await authRemoteDatasource.createUserCredential(userCredentialParams);

  }


} 