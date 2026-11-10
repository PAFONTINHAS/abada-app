import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_login_params.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/repository/auth_repository.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/validators/login_user_usecase_validator.dart';

class LoginUserUsecase {
  final AuthRepository authRepository;

  LoginUserUsecase(this.authRepository);

  Future<Either<Failure, void>> call(UserLoginParams userLoginParams) async {
    String? paramsValidator = LoginUserUsecaseValidator.validate(
      userLoginParams,
    );

    if (paramsValidator != null) return Left(ValidationFailure(paramsValidator));

    return await authRepository.authenticateUser(userLoginParams);
  }
}
