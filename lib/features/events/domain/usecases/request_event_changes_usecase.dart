import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_update_parameters.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_decision_parameters.dart';
import 'package:sistema_abada_capoeira/features/events/domain/repository/event_repository.dart';

class RequestEventChangesUsecase {
  final EventRepository repository;
  RequestEventChangesUsecase(this.repository);

  Future<Either<Failure, void>> call(EventRequestDecisionParameters params) {
    if (params.requestId.trim().isEmpty ||
        params.coordinatorId.trim().isEmpty) {
      return Future.value(
        const Left(ValidationFailure('Dados da decisão inválidos.')),
      );
    }

    if (params.reason.trim().isEmpty) {
      return Future.value(
        const Left(ValidationFailure('Descreva as alterações necessárias.')),
      );
    }

    return repository.requestChanges(
      GenericRequestUpdateParameters(
        requestId: params.requestId,
        changeReason: params.reason.trim(),
        additionalData: {
          'eventId': params.eventId,
          'decidedBy': params.coordinatorId,
          'decidedByName': params.coordinatorName,
          'decidedAt': null,
        },
      ),
    );
  }
}
