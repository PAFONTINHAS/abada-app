// Os metadados enviados pelo cliente precisam ser validados pelo backend
// ou pelas regras do Firestore, incluindo a identidade do coordenador.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/exception_handler.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_update_parameters.dart';

/// Operações genéricas de atualização de solicitações.
/// Não executa regras de negócio específicas das features.
class RequestDatasourceImpl {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Either<Failure, void>> approveGenericRequest(String collectionId,GenericRequestUpdateParameters params,
  ) {
    return _updateRequest(
      collectionId: collectionId,
      requestId: params.requestId,
      status: GenericRequestStatus.approved,
      contextMessage: 'approveGenericRequest',
    );
  }

  Future<Either<Failure, void>> rejectGenericRequest(String collectionId,GenericRequestUpdateParameters params,
  ) {
    return _updateRequest(
      collectionId: collectionId,
      requestId: params.requestId,
      status: GenericRequestStatus.rejected,
      additionalData: {
        'rejectionReason': params.rejectionReason,
        ...params.additionalData,
      },
      contextMessage: 'rejectGenericRequest',
    );
  }

  // Atualiza a solicitação e seus documentos relacionados na mesma transação.
  Future<Either<Failure, GenericRequestStatus>>updateGenericRequestWithTransaction({
    required String collectionId,
    required GenericRequestUpdateParameters params,
    GenericRequestStatus? expectedStatus,
    GenericRequestStatus? newStatus,
    Map<GenericRequestStatus, GenericRequestStatus>? transitions,
    required Future<void> Function(
      Transaction transaction,
      DocumentSnapshot<Map<String, dynamic>> requestSnapshot,
    ) updateRelatedDocuments,
    Map<String, dynamic> additionalData = const {},
  }) async {
    try {
      final requestReference = _firestore
          .collection(collectionId)
          .doc(params.requestId);

      final persistedStatus =await _firestore.runTransaction<GenericRequestStatus>((transaction) async {
          final requestSnapshot = await transaction.get(requestReference);

          if (!requestSnapshot.exists) {
            throw StateError('Solicitação não encontrada.');
          }

          final currentStatus = requestSnapshot.data()?['status'];
          final allowedTransitions = transitions ??
              {
                if (expectedStatus != null && newStatus != null)
                  expectedStatus: newStatus,
              };
          final source = GenericRequestStatusExtension.fromString(
            currentStatus is String ? currentStatus : '',
          );
          final destination = allowedTransitions[source];

          if (destination == null) {
            throw StateError('A solicitação não está no status esperado.');
          }

          await updateRelatedDocuments(transaction, requestSnapshot);

          transaction.update(requestReference, {
            ...additionalData,
            'status': destination.name,
            'updatedAt': FieldValue.serverTimestamp(),
          });
          return destination;
        },
      );

      return Right(persistedStatus);
    } on StateError catch (exception) {
      return Left(ValidationFailure(exception.message.toString()));
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'updateGenericRequestWithTransaction',
      );
    }
  }

  Future<Either<Failure, void>> requestGenericChanges(String collectionId,GenericRequestUpdateParameters params,
  ) {
    return _updateRequest(
      collectionId: collectionId,
      requestId: params.requestId,
      status: GenericRequestStatus.changesRequested,
      additionalData: {
        'changeReason': params.changeReason,
        ...params.additionalData,
      },
      contextMessage: 'requestGenericChanges',
    );
  }

  // Atualiza a solicitação sem modificar documentos relacionados.
  Future<Either<Failure, void>> updateGenericRequest(
    String collectionId,
    GenericRequestUpdateParameters params,
    GenericRequestStatus status, {
    Map<String, dynamic> additionalData = const {},
  }) {
    return _updateRequest(
      collectionId: collectionId,
      requestId: params.requestId,
      status: status,
      additionalData: additionalData,
      contextMessage: 'updateGenericRequest',
    );
  }

  Future<Either<Failure, void>> _updateRequest({
    required String collectionId,
    required String requestId,
    required GenericRequestStatus status,
    required String contextMessage,
    Map<String, dynamic> additionalData = const {},
  }) async {
    try {
      await _firestore.collection(collectionId).doc(requestId).update({
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
        ...additionalData,
      });

      return const Right(null);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: contextMessage,
      );
    }
  }
}