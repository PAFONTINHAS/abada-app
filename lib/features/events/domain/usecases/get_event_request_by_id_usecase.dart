
import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/repository/event_repository.dart';

class GetEventRequestByIdUsecase {
  final EventRepository repository;

  GetEventRequestByIdUsecase(this.repository);

  Future<Either<Failure, EventRequestEntity>> call(String requestId) {
    if (requestId.trim().isEmpty) {
      return Future.value(const Left(ValidationFailure('ID da solicitação inválido.'),),);
    }
    return repository.getEventRequestById(requestId);
  }
}
