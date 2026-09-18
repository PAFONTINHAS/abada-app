import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/repository/profile_repository.dart';

class DeactivateAccountUseCase {
  final ProfileRepository repository;

  DeactivateAccountUseCase(this.repository);

  Future<Either<Failure, UserProfileEntity>> execute(
    UserProfileEntity userProfile,
  ) async {
    final updatedProfile = userProfile.copyWith(isActive: false);
    return await repository.updateUserEntity(updatedProfile);
  }
}
