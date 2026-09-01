import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/repository/auth_repository.dart';

class LogoutUserUsecase {

  AuthRepository repository;

  LogoutUserUsecase(this.repository);


  Future<Either<Failure, void>> call() async{

    return await repository.logoutUser();

  }

}