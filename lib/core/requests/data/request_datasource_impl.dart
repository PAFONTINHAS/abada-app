//Observação de segurança: essa extensão permite enviar metadados, mas não garante que eles sejam verdadeiros. Para produção, o backend ou as regras do Firestore precisam validar a identidade do coordenador e impedir que o cliente falsifique quem tomou a decisão.
import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/errors/exception_handler.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_update_parameters.dart';

/// Operações genéricas de atualização de solicitações.
/// Não executa regras de negócio específicas das features.
class RequestDatasourceImpl {
  final FirebaseFirestore _firestore;

  RequestDatasourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<Either<Failure, void>> approveGenericRequest(
    String collectionId,
    GenericRequestUpdateParameters params,
  ) {
    return _updateRequest(
      collectionId: collectionId,
      requestId: params.requestId,
      status: GenericRequestStatus.approved,
      contextMessage: 'approveGenericRequest',
    );
  }

  Future<Either<Failure, void>> rejectGenericRequest(
    String collectionId,
    GenericRequestUpdateParameters params,
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

  // Atualiza uma solicitação e seus documentos relacionados em uma única transação,
  //garantindo que todas as alterações sejam salvas juntas ou nenhuma seja aplicada.
  Future<Either<Failure, void>> updateGenericRequestWithTransaction({
    required String collectionId,
    required GenericRequestUpdateParameters params,
    GenericRequestStatus? expectedStatus,
    GenericRequestStatus? newStatus,
    Map<GenericRequestStatus, GenericRequestStatus>? transitions,
    required Future<void> Function(
      Transaction transaction,
      DocumentSnapshot<Map<String, dynamic>> requestSnapshot,
    )
    updateRelatedDocuments,
    Map<String, dynamic> additionalData = const {},
  }) async {
    try {
      final requestReference = _firestore
          .collection(collectionId)
          .doc(params.requestId);

      await _firestore.runTransaction((transaction) async {
        final requestSnapshot = await transaction.get(requestReference);

        if (!requestSnapshot.exists) {
          throw StateError('Solicitação não encontrada.');
        }

        final currentStatus = requestSnapshot.data()?['status'];

        final allowedTransitions =
            transitions ??
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
      });

      return const Right(null);
    } on StateError catch (exception) {
      return Left(ValidationFailure(exception.message.toString()));
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'updateGenericRequestWithTransaction',
      );
    }
  }

  Future<Either<Failure, void>> requestGenericChanges(
    String collectionId,
    GenericRequestUpdateParameters params,
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

  // Atualiza o status e os metadados de uma solicitação existente, sem modificar documentos relacionados.
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
