import 'package:sistema_abada_capoeira/core/errors/exception_handler.dart';
import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/profile_change_request_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/repository/profile_repository.dart';

class RequestBeltNicknameChangeUseCase {
  final ProfileRepository repository;

  RequestBeltNicknameChangeUseCase(this.repository);

  Future<Either<Failure, void>> execute({
    required String originalBelt,
    required String originalNickname,
    String? newBelt,
    String? newNickname,
  }) async {
    
    if (newBelt == null && newNickname == null) {
      return const Left(
        ValidationFailure('Informe uma nova corda ou apelido.'),
      );
    }

    final profileResult = await repository.getCurrentUserProfile();
    return profileResult.fold(
      (failure) => Left(failure),
      (profile) => repository.createChangeRequest(
        ProfileChangeRequestEntity(
          id: '',
          userId: profile.id,
          userName: profile.displayName,
          originalBelt: originalBelt,
          originalNickname: originalNickname,
          newBelt: newBelt,
          newNickname: newNickname,
          status: ProfileChangeRequestStatus.pending,
        ),
      ),
    );

  }
}
