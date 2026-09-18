import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/fee_exemption_request_entity.dart';
import '../repository/fee_exemption_repository.dart';

class GetFeeExemptionRequestUsecase {
  final FeeExemptionRepository repository;

  GetFeeExemptionRequestUsecase(this.repository);

  Future<Either<Failure,FeeExemptionRequestEntity>> call (String feeExemptionId) async{
    return await repository.getFeeExemptionRequest(feeExemptionId);
  }
}
