import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../core/errors/exception_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/fee_exemption_file_entity.dart';
import '../../domain/entities/fee_exemption_request_status_enum.dart';
import '../model/fee_exemption_document_model.dart';
import '../model/fee_exemption_request_model.dart';
import 'fee_exemption_remote_datasource.dart';

class FeeExemptionRemoteDataSourceImpl implements FeeExemptionRemoteDataSource {
  //implementa cada ação do data source
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  static const String _requestsCollection = 'fee_exemption_requests';

  //nova solicitação de isenção
  @override
  Future<Either<Failure, String>> submitRequest(
    FeeExemptionRequestModel request,
    FeeExemptionFileEntity file,
  ) async {
    try {
      // Reserva uma referência/endereço para onde a solicitação será salva no Firestore.
      // como doc foi chamado sem id, ele cria automaticamente
      final requestRef = firestore.collection(_requestsCollection).doc();

      final feeExemptionId = requestRef.id;
      const version = 1;
      final storagePath =
          'fee_exemptions/'
          '${request.professorId}/'
          '$feeExemptionId/'
          '${version}_${file.fileName}';
      //monta o end do pdf no storage ex: fee_exemptions/prof123/ABC123/1_declaracao.pdf
      // Faz o upload do PDF real para o Firebase Storage.

      await storage
          .ref(storagePath)
          .putData(
            file.bytes,
            SettableMetadata(contentType: 'application/pdf'),
          );
      // Salva a solicitação
      await requestRef.set(request.toMap());

      // criando uma subcollection de pdf dentro da solicitação, gerando id para o pdf
      final documentRef = requestRef.collection('documents').doc();

      //cria o obj dart que enviamos no firebase
      final document = FeeExemptionDocumentModel(
        id: documentRef.id,
        requestId: feeExemptionId,
        fileName: file.fileName,
        storagePath: storagePath,
        version: version,
        uploadedBy: request.professorId,
        uploadedAt: DateTime.now(),
      );

      //transforma o obj em map e salva os metadados no firestore
      await documentRef.set(document.toMap());

      return Right(feeExemptionId);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'submitFeeExemptionRequest',
      );
    }
  }

  //busca solicitação
  @override
  Future<Either<Failure, FeeExemptionRequestModel>> getFeeExemptionRequest(
    String feeExemptionId,
  ) async {
    try {
      final snapshot = await firestore
          .collection(_requestsCollection)
          .doc(feeExemptionId)
          .get();

      if (!snapshot.exists || snapshot.data() == null) {
        return const Left(
          NotFoundFailure('Solicitação de isenção não encontrada.'),
        );
      }

      final request = FeeExemptionRequestModel.fromMap(
        snapshot.id,
        snapshot.data()!,
      );

      return Right(request);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'getFeeExemptionRequest',
      );
    }
  }

  //buscar documentos pdf
  @override
  Future<Either<Failure, List<FeeExemptionDocumentModel>>> getRequestDocuments(
    String feeExemptionId,
  ) async {
    try {
      final snapshot = await firestore
          .collection(_requestsCollection)
          .doc(feeExemptionId)
          .collection('documents')
          .orderBy('version')
          .get();

      final documents = snapshot.docs.map((doc) {
        //Para cada doc atual da repetição dessa lista:
        return FeeExemptionDocumentModel.fromMap(doc.id, doc.data());
      }).toList();

      return Right(documents);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'getFeeExemptionDocuments',
      );
    }
  }

  //enviar complementação
  @override
  Future<Either<Failure, void>> submitComplementation(
    String feeExemptionId,
    FeeExemptionFileEntity file,
  ) async {
    try {
      //procura no firestore a solicitação
      final requestRef = firestore
          .collection(_requestsCollection)
          .doc(feeExemptionId);

      //traz a solicitação
      final requestSnapshot = await requestRef.get();

      //verifica se realmente existe
      if (!requestSnapshot.exists || requestSnapshot.data() == null) {
        return const Left(
          NotFoundFailure('Solicitação de isenção não encontrada.'),
        );
      }
      //firestore-> model
      final request = FeeExemptionRequestModel.fromMap(
        requestSnapshot.id,
        requestSnapshot.data()!,
      );

      // Busca somente a versão mais recente.
      final documentsSnapshot = await requestRef
          .collection('documents')
          .orderBy('version', descending: true)
          .limit(1)
          .get();

      //caso nao existe doc anterior, suponha a v1
      int newVersion = 1;

      if (documentsSnapshot.docs.isNotEmpty) {
        //se nao tiver vazia pega o 1o doc e transf em model
        final lastDocument = FeeExemptionDocumentModel.fromMap(
          documentsSnapshot.docs.first.id,
          documentsSnapshot.docs.first.data(),
        );
        newVersion = lastDocument.version + 1;
      }

      final storagePath =
          'fee_exemptions/'
          '${request.professorId}/'
          '$feeExemptionId/'
          '${newVersion}_${file.fileName}';

      // Salva o novo PDF sem apagar nenhum anterior.
      await storage
          .ref(storagePath)
          .putData(
            file.bytes,
            SettableMetadata(contentType: 'application/pdf'),
          );
      final documentRef = requestRef.collection('documents').doc();

      final document = FeeExemptionDocumentModel(
        id: documentRef.id,
        requestId: feeExemptionId,
        fileName: file.fileName,
        storagePath: storagePath,
        version: newVersion,
        uploadedBy: request.professorId,
        uploadedAt: DateTime.now(),
      );

      //salva os metadados no firestore
      await documentRef.set(document.toMap());

      // A solicitação volta para análise
      await requestRef.update({
        'status': FeeExemptionStatus.updated.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return const Right(null);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'submitFeeExemptionComplementation',
      );
    }
  }

  @override
  Future<Either<Failure, String>> getDocumentDownloadUrl(
    String storagePath,
  ) async {
    try {
      final downloadUrl = await storage.ref(storagePath).getDownloadURL();

      return Right(downloadUrl);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'getFeeExemptionDocumentDownloadUrl',
      );
    }
  }
}
