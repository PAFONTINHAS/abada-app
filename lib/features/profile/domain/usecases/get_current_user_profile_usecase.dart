import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/repository/profile_repository.dart';

class GetCurrentUserProfileUsecase {

  ProfileRepository profileRepository;

  GetCurrentUserProfileUsecase(this.profileRepository);

  Future<Either<Failure, UserProfileEntity>> call() async{

    return await profileRepository.getCurrentUserProfile();

  }

}