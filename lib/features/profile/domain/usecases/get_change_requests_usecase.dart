import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/profile_change_request_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/repository/profile_repository.dart';

class GetChangeRequestsUseCase {
  final ProfileRepository repository;

  GetChangeRequestsUseCase(this.repository);

  Future<Either<Failure, List<ProfileChangeRequestEntity>>> execute() async {
    
    final result = await repository.getMyChangeRequests();

    return result.map((requests) {
      requests.sort(
        (first, second) => (second.requestDate ?? DateTime(0)).compareTo(
          first.requestDate ?? DateTime(0),
        ),
      );
      return requests;
    });
  }
}
