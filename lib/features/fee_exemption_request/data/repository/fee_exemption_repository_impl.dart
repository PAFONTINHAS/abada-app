// esse arquivo recebe as operações do Domain e as encaminha para o DataSource,
//fazendo as conversões necessárias entre Entity e Model.
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/fee_exemption_document_entity.dart';
import '../../domain/entities/fee_exemption_file_entity.dart';
import '../../domain/entities/fee_exemption_request_entity.dart';
import '../../domain/repository/fee_exemption_repository.dart';
import '../datasource/fee_exemption_remote_datasource.dart';
import '../model/fee_exemption_request_model.dart';

class FeeExemptionRepositoryImpl implements FeeExemptionRepository {
  final FeeExemptionRemoteDataSource remoteDataSource;

  FeeExemptionRepositoryImpl(this.remoteDataSource);

  @override
  // Converte a entidade da solicitação em Model e pede ao DataSource para criar a solicitação e enviar o arquivo.
  Future<Either<Failure, String>> submitRequest(
    FeeExemptionRequestEntity request,
    FeeExemptionFileEntity file,
  ) async {
    final requestModel = FeeExemptionRequestModel(
      idExemptionRequest: request.idExemptionRequest,
      professorId: request.professorId,
      professorName: request.professorName,
      status: request.status,
      requestedAt: request.requestedAt,
      updatedAt: request.updatedAt,
      approvedAt: request.approvedAt,
      validUntil: request.validUntil,
    );
    return await remoteDataSource.submitRequest(requestModel, file);
  }

  @override
  // Pede ao DataSource para buscar uma solicitação de isenção específica pelo seu ID.
  Future<Either<Failure, FeeExemptionRequestEntity>> getFeeExemptionRequest(
    String feeExemptionId,
  ) async {
    return await remoteDataSource.getFeeExemptionRequest(feeExemptionId);
  }

  @override
  // Pede ao DataSource para buscar todas as versões dos documentos vinculados à solicitação.
  Future<Either<Failure, List<FeeExemptionDocumentEntity>>> getRequestDocuments(
    String feeExemptionId,
  ) async {
    return await remoteDataSource.getRequestDocuments(feeExemptionId);
  }

  @override
  // Pede ao DataSource para enviar uma nova versão do documento de uma solicitação existente.
  Future<Either<Failure, void>> submitComplementation(
    String feeExemptionId,
    FeeExemptionFileEntity file,
  ) async {
    return await remoteDataSource.submitComplementation(feeExemptionId, file);
  }

  @override
  Future<Either<Failure, String>> getDocumentDownloadUrl(
    String storagePath,
  ) async {
    return await remoteDataSource.getDocumentDownloadUrl(storagePath);
  }
}
