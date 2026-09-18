import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import '../../domain/repository/account_deactivation_repository.dart';
import '../datasources/account_deactivation_remote_datasource.dart';

class AccountDeactivationRepositoryImpl
    implements AccountDeactivationRepository {
  final AccountDeactivationRemoteDatasource remoteDatasource;

  AccountDeactivationRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failure, void>> deactivateAccount(String userId) {
    return remoteDatasource.deactivateAccount(userId);
  }
}
