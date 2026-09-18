import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/exception_handler.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'account_deactivation_remote_datasource.dart';

class AccountDeactivationRemoteDatasourceImpl
    implements AccountDeactivationRemoteDatasource {
  final FirebaseFirestore firestore;

  AccountDeactivationRemoteDatasourceImpl({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<Failure, void>> deactivateAccount(String userId) async {
    try {
      await firestore.collection('users').doc(userId).update({
        'isActive': false,
      });
      return const Right(null);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'deactivateAccount',
      );
    }
  }
}
