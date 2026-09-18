import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/features/fee_exemption_request/domain/entities/fee_exemption_file_entity.dart';
import '../../../../core/errors/failure.dart';
import '../model/fee_exemption_document_model.dart';
import '../model/fee_exemption_request_model.dart';

abstract class FeeExemptionRemoteDataSource {
  // Cria uma nova solicitação de isenção
  // e registra o primeiro doc
  Future<Either<Failure, String>> submitRequest(
    FeeExemptionRequestModel request,
    FeeExemptionFileEntity  file,
  );

  // Busca uma solicitação específica pelo id.
  Future<Either<Failure, FeeExemptionRequestModel>>getFeeExemptionRequest(String feeExemptionId,);

  // Busca todas as versões de documentos
  // vinculadas a uma solicitação.
  Future<Either<Failure, List<FeeExemptionDocumentModel>>>getRequestDocuments(String feeExemptionId,);

  // Envia uma nova versão de documento
  // após solicitação de complementação.
  Future<Either<Failure, void>> submitComplementation(
    String feeExemptionId,
    FeeExemptionFileEntity  file,
  );
  
  Future<Either<Failure, String>> getDocumentDownloadUrl(String storagePath,);
}