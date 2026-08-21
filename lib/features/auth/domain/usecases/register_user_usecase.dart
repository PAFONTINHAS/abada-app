import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_credential_params.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_entity.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_registration_params.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/repository/auth_repository.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/validators/register_user_usecase_validator.dart';

class RegisterUserUsecase {

  AuthRepository authRepository;

  RegisterUserUsecase(this.authRepository);


  Future<Either<Failure, UserEntity>> call(UserRegistrationParams userRegistrationParams) async{

    final String? emptyFieldError = RegisterUserUsecaseValidator.validateEmptyness(userRegistrationParams);
    final String? passwordsError = RegisterUserUsecaseValidator.validatePasswords(userRegistrationParams);

    if(emptyFieldError != null) return Left(ValidationFailure(emptyFieldError));
    if(passwordsError != null) return Left(ValidationFailure(passwordsError));

    final createUserCredential = await authRepository.createUserCredential(
      UserCredentialParams(
        email: userRegistrationParams.email, 
        password: userRegistrationParams.password
      )
    );

    return createUserCredential.fold(
      (failure) => Left(failure),
      (userCredential) async {

        if (userCredential.user == null) return Left(UnknownFailure("Erro ao criar credenciais do usuário"));

        UserEntity userEntity = UserEntity.fromRegisterParams(userCredential, userRegistrationParams);

        return await authRepository.registerUser(userEntity);

      }
    );

    

  }

}