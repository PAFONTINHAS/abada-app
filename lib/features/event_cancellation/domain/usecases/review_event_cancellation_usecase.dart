import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/domain/entities/event_cancellation_request_entity.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/domain/repository/event_cancellation_repository.dart';

class ReviewEventCancellationUseCase {
  const ReviewEventCancellationUseCase(this.repository);

  final EventCancellationRepository repository;

  Future<Either<Failure, EventCancellationRequestEntity>> call({
    required EventCancellationRequestEntity request,
    required bool approve,
    required String reviewerId,
  }) {
    if (request.status != EventCancellationStatus.pending) {
      return Future.value(
        const Left(ValidationFailure('Esta solicitação já foi analisada.')),
      );
    }
    return repository.reviewCancellation(
      request: request,
      approve: approve,
      reviewerId: reviewerId,
    );
  }
}
