import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/errors/exception_handler.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_creation_parameters.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_update_parameters.dart';


/// Operações genéricas de atualização de solicitações.
/// Não executa regras de negócio específicas das features.
class RequestDatasourceImpl {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Either<Failure, void>> approveGenericRequest(String collectionId, GenericRequestUpdateParameters params,) {
    return _updateRequest(
      collectionId: collectionId,
      requestId: params.requestId,
      status: GenericRequestStatus.approved,
      contextMessage: 'approveGenericRequest',
    );
  }

  Future<Either<Failure, void>> rejectGenericRequest(String collectionId, GenericRequestUpdateParameters params,) {
    return _updateRequest(
      collectionId: collectionId,
      requestId: params.requestId,
      status: GenericRequestStatus.rejected,
      additionalData: {'rejectionReason': params.rejectionReason},
      contextMessage: 'rejectGenericRequest',
    );
  }

  Future<Either<Failure, void>> requestGenericChanges(String collectionId, GenericRequestUpdateParameters params,) {
    return _updateRequest(
      collectionId: collectionId,
      requestId: params.requestId,
      status: GenericRequestStatus.changesRequested,
      additionalData: {'changeReason': params.changeReason},
      contextMessage: 'requestGenericChanges',
    );
  }

  Future<Either<Failure, void>> updateGenericRequest(String collectionId, GenericRequestUpdateParameters params, GenericRequestStatus status, {
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
