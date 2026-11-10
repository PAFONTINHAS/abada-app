import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';

class ValidateDecisionReasonUsecase {
  Either<Failure, void> call({
    required GenericRequestStatus destination, //status que a soli irá receber dps
    required String reason, //justificativa
  }) {

    final requiresReason =
    destination == GenericRequestStatus.rejected ||
    destination == GenericRequestStatus.changesRequested;
    
    if (requiresReason && reason.trim().isEmpty) {
      return const Left(ValidationFailure('Informe o motivo da decisão.'));
    }
    return const Right(null);
  }
}
