import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import '../repository/account_deactivation_repository.dart';

class DeactivateAccountUseCase {
  final AccountDeactivationRepository repository;

  DeactivateAccountUseCase(this.repository);

  Future<Either<Failure, void>> execute(String userId) {
    return repository.deactivateAccount(userId);
  }
}
