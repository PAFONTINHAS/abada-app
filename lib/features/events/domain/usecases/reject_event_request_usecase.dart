import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_update_parameters.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_decision_parameters.dart';
import 'package:sistema_abada_capoeira/features/events/domain/repository/event_repository.dart';

class RejectEventRequestUsecase {
  final EventRepository repository;
  //recebe o repository por injeção de dependencia
  RejectEventRequestUsecase(this.repository);

  Future<Either<Failure, void>> call(EventRequestDecisionParameters params) {
    if (params.requestId.trim().isEmpty ||
        params.coordinatorId.trim().isEmpty) {
      return Future.value(
        const Left(ValidationFailure('Dados da decisão inválidos.')),
      );
    }

    if (params.reason.trim().isEmpty) {
      return Future.value(
        const Left(ValidationFailure('O motivo da recusa é obrigatório.')),
      );
    }

    return repository.rejectRequest(
      GenericRequestUpdateParameters(
        //crie o obj de parametros
        requestId: params.requestId,
        rejectionReason: params.reason.trim(),
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
