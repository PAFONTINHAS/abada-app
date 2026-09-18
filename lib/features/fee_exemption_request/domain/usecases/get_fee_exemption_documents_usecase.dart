import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/domain/entities/fee_exemption_document_entity.dart';
import '../../../../core/errors/failure.dart';
import '../repository/fee_exemption_repository.dart';

class GetFeeExemptionDocumentsUsecase {
  final FeeExemptionRepository repository;

  GetFeeExemptionDocumentsUsecase(this.repository);

  Future<Either<Failure, List<FeeExemptionDocumentEntity>>> call(String feeExemptionId,
  ) async {
    return await repository.getRequestDocuments(feeExemptionId);
  }
}
