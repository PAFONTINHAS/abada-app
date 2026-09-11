import 'package:sistema_abada_capoeira/core/errors/exception_handler.dart';
import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/repository/profile_repository.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/validators/info_profile_validator.dart';

class UpdateProfileInfoUseCase {
  final ProfileRepository repository;

  UpdateProfileInfoUseCase(this.repository);

  Future<Either<Failure, void>> execute({
    required String fullName,
    required String email,
    required String phoneNumber,
  }) async {

    if (!InfoProfileValidator.isValidFullName(fullName)) {
      return const Left(ValidationFailure('Invalid full name'));
    }

    if (!InfoProfileValidator.isValidEmail(email)) {
      return const Left(ValidationFailure('Invalid email'));
    }

    if (!InfoProfileValidator.isValidPhoneNumber(phoneNumber)) {
      return const Left(ValidationFailure('Invalid phone number'));
    }

    final profileResult = await repository.getCurrentUserProfile();
    
    return profileResult.fold(
      (failure) => Left(failure),
      (currentProfile) => repository.updateUserEntity(
        UserProfileEntity(
          id: currentProfile.id,
          nickname: currentProfile.nickname,
          fullName: fullName,
          email: email,
          phoneNumber: phoneNumber,
          currentBeltName: currentProfile.currentBeltName,
          role: currentProfile.role,
          tuscaStatus: currentProfile.tuscaStatus,
          tuscaExpirationDate: currentProfile.tuscaExpirationDate,
          photoUrl: currentProfile.photoUrl,
          city: currentProfile.city,
          state: currentProfile.state,
        ),
      ),
    );

  }
}
