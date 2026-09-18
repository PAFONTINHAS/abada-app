import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';

abstract class AccountDeactivationRemoteDatasource {
  Future<Either<Failure, void>> deactivateAccount(String userId);
}
