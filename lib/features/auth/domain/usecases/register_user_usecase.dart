import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_credential_params.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_entity.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/entities/user_registration_params.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/repository/auth_repository.dart';
import 'package:sistema_abada_capoeira/features/auth/domain/validators/register_user_usecase_validator.dart';
import 'package:sistema_abada_capoeira/features/member_validation/domain/entities/membership_request.dart';
import 'package:sistema_abada_capoeira/features/member_validation/domain/entities/membership_request_status.dart';
import 'package:sistema_abada_capoeira/features/member_validation/domain/repository/membership_validation_repostitory.dart';

class RegisterUserUsecase {

  AuthRepository authRepository;
  MembershipValidationRepository membershipValidationRepository;

  RegisterUserUsecase(this.authRepository, this.membershipValidationRepository);


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

        final registerUser = await authRepository.registerUser(userEntity);

        return registerUser.fold((failure) => Left(failure), (userEntity) async{

          final MembershipRequest membershipRequest = MembershipRequest(
            id: '',
            status: MembershipRequestStatus.requested,
            classId: 'KZ4v5bkXtgdNXKftkGK5',
            memberId: userEntity.uid,
            className: "Turma CEP",
            memberBelt: userEntity.belt,
            memberName: userEntity.fullName,
            professorId: "ymm7Mvj1jmSoPrndCJR9LjnVhbQ2",
            requestedAt: DateTime.now(),
            memberNickname: userEntity.nickname,
          );

          final createMembershipRequest = await membershipValidationRepository.createMembershipRequest(membershipRequest);

          return createMembershipRequest.fold(
            (failure) => Left(failure),
            (_) => Right(userEntity),
          );
        });
      }
    );
  }
}