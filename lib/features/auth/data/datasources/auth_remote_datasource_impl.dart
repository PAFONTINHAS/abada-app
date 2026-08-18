import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/errors/exception_handler.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_entity.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_credential_params.dart';
import 'package:sistema_abada_capoeira/features/auth/data/datasources/auth_remote_datasource.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, UserEntity>> registerUser(UserEntity user) async{

    try{

      final docRef = _firestore.collection('users').doc(user.uid);

      await docRef.set(user.toMap());

      return Right(user);
    } catch(e){
      return ExceptionHandler.handleException(exception: e, contextMessage: "registerUser");
    }
  }

  @override
  Future<Either<Failure, UserCredential>> createUserCredential(UserCredentialParams userCredentialParams) async{

    try{


      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: userCredentialParams.email,
        password: userCredentialParams.password,
      );


      return Right(userCredential);

    }catch(e){

      return ExceptionHandler.handleException(exception: e, contextMessage: "createUserCredential");
    }

  }





} 