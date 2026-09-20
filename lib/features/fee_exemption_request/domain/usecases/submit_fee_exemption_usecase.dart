import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/domain/entities/fee_exemption_file_entity.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/domain/entities/fee_exemption_request_entity.dart';
import '../../../../core/errors/failure.dart';
import '../repository/fee_exemption_repository.dart';

class SubmitFeeExemptionUsecase {
  final FeeExemptionRepository repository;

  SubmitFeeExemptionUsecase(this.repository);

  Future<Either<Failure, String>> call({
    required FeeExemptionRequestEntity request,
    required FeeExemptionFileEntity  file,
  //precisa receber as entidades pq a solicitação nao existe
  }) async {
    return await repository.submitRequest(request, file);
  }
}
