import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/errors/exception_handler.dart';

class GenericRequestParameters {
  final String requestId;
  final String rejectionReason;
  final String changeReason;

  const GenericRequestParameters({
    required this.requestId,
    this.rejectionReason = '',
    this.changeReason = '',
  });
}

/// Operações genéricas de atualização de solicitações.
/// Não executa regras de negócio específicas das features.
class RequestDatasourceImpl {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Either<Failure, void>> approveGenericRequest(String collectionId,GenericRequestParameters params,) {
    return _updateRequest(
      collectionId: collectionId,
      requestId: params.requestId,
      status: 'approved',
      contextMessage: 'approveGenericRequest',
    );
  }

  Future<Either<Failure, void>> rejectGenericRequest(String collectionId,GenericRequestParameters params,) {
    return _updateRequest(
      collectionId: collectionId,
      requestId: params.requestId,
      status: 'rejected',
      additionalData: {'rejectionReason': params.rejectionReason},
      contextMessage: 'rejectGenericRequest',
    );
  }

  Future<Either<Failure, void>> requestGenericChanges(String collectionId,GenericRequestParameters params,) {
    return _updateRequest(
      collectionId: collectionId,
      requestId: params.requestId,
      status: 'changesRequested',
      additionalData: {'changeReason': params.changeReason},
      contextMessage: 'requestGenericChanges',
    );
  }

  Future<Either<Failure, void>> updateGenericRequest(String collectionId, GenericRequestParameters params, String status, {
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
    required String status,
    required String contextMessage,
    Map<String, dynamic> additionalData = const {},
  }) async {
    try {
      await firestore.collection(collectionId).doc(requestId).update({
        'status': status,
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
