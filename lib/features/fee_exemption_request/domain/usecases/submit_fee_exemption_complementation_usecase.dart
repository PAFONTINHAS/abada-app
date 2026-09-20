import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/domain/entities/fee_exemption_file_entity.dart';
import '../../../../core/errors/failure.dart';
import '../repository/fee_exemption_repository.dart';

class SubmitFeeExemptionComplementationUsecase {
  final FeeExemptionRepository repository;

  SubmitFeeExemptionComplementationUsecase(this.repository);

  Future<Either<Failure, void>> call(
    String feeExemptionId,
    FeeExemptionFileEntity file,
  ) async {
    return await repository.submitComplementation(feeExemptionId, file);
  }
}
