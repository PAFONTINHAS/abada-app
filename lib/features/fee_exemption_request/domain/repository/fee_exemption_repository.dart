import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/domain/entities/fee_exemption_file_entity.dart';
import '../../../../core/errors/failure.dart';
import '../entities/fee_exemption_document_entity.dart';
import '../entities/fee_exemption_request_entity.dart';

abstract class FeeExemptionRepository {

  // Cria uma nova solicitação de isenção.
  Future<Either<Failure, String>> submitRequest(
    FeeExemptionRequestEntity request,
    FeeExemptionFileEntity file,
  );

  // Busca a solicitação de isenção do professor.
  Future<Either<Failure, FeeExemptionRequestEntity>> getFeeExemptionRequest(
    String feeExemptionId,
  );

  // Busca todas as versões de documentos
  // vinculadas a uma solicitação.
  Future<Either<Failure, List<FeeExemptionDocumentEntity>>> getRequestDocuments(
    String document,
  );

  // Envia uma nova versão do documento
  // após solicitação de complementação.
  Future<Either<Failure, void>> submitComplementation(
    String feeExemptionId,
    FeeExemptionFileEntity  file,
  );

  Future<Either<Failure, String>> getDocumentDownloadUrl(String storagePath,);
}
