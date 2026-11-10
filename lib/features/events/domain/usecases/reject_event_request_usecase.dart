
import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_update_parameters.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/usecases/validation_decide_reason_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_decision_parameters.dart';
import 'package:sistema_abada_capoeira/features/events/domain/repository/event_repository.dart';

class RejectEventRequestUsecase {
  final EventRepository repository;
  //recebe o repository por injeção de dependencia
  RejectEventRequestUsecase(this.repository);

Future<Either<Failure, void>> call(EventRequestDecisionParameters params,) async {
  if (params.requestId.trim().isEmpty ||
      params.eventId.trim().isEmpty ||
      params.coordinatorId.trim().isEmpty) {
    return const Left(ValidationFailure('Dados da decisão inválidos.'));
  }

  final validation = ValidateDecisionReasonUsecase()(
    destination: GenericRequestStatus.rejected,
    reason: params.reason,
  );

  if (validation.isLeft()) {
    return validation;
  }

  final requestResult = await repository.getEventRequestById(params.requestId);

  return requestResult.fold<Future<Either<Failure, void>>>(
    (failure) async => Left(failure),
    (request) async {
      if (request.eventId != params.eventId) {
        return const Left(
          ValidationFailure('A solicitação não pertence ao evento informado.'),
        );
      }

      return repository.rejectRequest(
        GenericRequestUpdateParameters(
          requestId: params.requestId,
          rejectionReason: params.reason.trim(),
          additionalData: {
            'eventId': params.eventId,
            'decidedBy': params.coordinatorId,
            'decidedByName': params.coordinatorName,
          },
          transitions: const {
            GenericRequestStatus.requested: GenericRequestStatus.rejected,
            GenericRequestStatus.updated: GenericRequestStatus.rejected,
          },
        ),
      );
    },
  );
}
}