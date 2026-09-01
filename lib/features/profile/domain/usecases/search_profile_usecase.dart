import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/repository/profile_repository.dart';

class SearchProfileUseCase {
  final ProfileRepository repository;

  SearchProfileUseCase(this.repository);

  Future<UserProfileEntity> execute(String userId) async {
    return await repository.searchProfile(userId);
  }
}
