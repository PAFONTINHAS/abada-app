import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/profile_change_request_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/repository/profile_repository.dart';

class DecideChangeRequestUseCase {
  final ProfileRepository repository;

  DecideChangeRequestUseCase(this.repository);

  Future<Either<Failure, void>> execute({
    required ProfileChangeRequestEntity request,
    required bool approve,
  }) async {

    if (request.status != ProfileChangeRequestStatus.pending) {
      return const Left(
        ValidationFailure('Esta solicitação já foi analisada.'),
      );
    }

    final status = approve
        ? ProfileChangeRequestStatus.approved
        : ProfileChangeRequestStatus.rejected;
        
    final profileUpdates = <String, dynamic>{};
    
    if (request.newBelt != null) {
      profileUpdates['currentBeltName'] = request.newBelt;
    }
    
    if (request.newNickname != null) {
      profileUpdates['nickname'] = request.newNickname;
    }
    
    if (approve && profileUpdates.isEmpty) {
      return const Left(
        ValidationFailure('A solicitação não possui alterações.'),
      );
    }

    return repository.updateChangeRequest(
      request: request,
      status: status,
      profileUpdates: profileUpdates,
    );
  }
}
