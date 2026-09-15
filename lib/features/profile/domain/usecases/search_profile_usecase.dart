import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/repository/profile_repository.dart';

class SearchProfileUseCase {
  final ProfileRepository repository;

  SearchProfileUseCase(this.repository);

  Future<Either<Failure, UserProfileEntity>> execute(String userId) async {
    return repository.searchProfile(userId);
  }
}


