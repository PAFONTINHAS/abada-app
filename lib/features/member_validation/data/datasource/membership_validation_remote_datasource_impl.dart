import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import 'package:sistema_abada_capoeira/core/errors/exception_handler.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/requests/data/request_datasource_impl.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_creation_parameters.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_update_parameters.dart';
import 'package:sistema_abada_capoeira/features/member_validation/domain/entities/membership_request.dart';
import '../../domain/entities/membership_request_status.dart';
import '../model/membership_request_model.dart';
import 'membership_validation_remote_datasource.dart';

class MembershipValidationRemoteDataSourceImpl extends RequestDatasourceImpl
    implements MembershipValidationRemoteDataSource {
  static const String _collectionId = 'membership_requests';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, void>> createMembershipRequest(
    MembershipRequest request,
  ) async {
    try {
      final model = MembershipRequestModel.fromEntity(request);
      await _firestore.collection(_collectionId).doc().set(model.toMap());
      return const Right(null);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'createMembershipRequest',
      );
    }
  }

  @override
  Future<Either<Failure, List<MembershipRequestModel>>> getProfessorRequests(
    String professorId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionId)
          .where('professorId', isEqualTo: professorId)
          .where(
            'status',
            whereIn: [
              MembershipRequestStatus.requested.name,
              MembershipRequestStatus.updated.name,
            ],
          )
          .get();

      final requests = snapshot.docs
          .map((doc) => MembershipRequestModel.fromMap(doc.id, doc.data()))
          .toList();

      return Right(requests);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'getProfessorRequests',
      );
    }
  }

  @override
  Future<Either<Failure, void>> approveRequest(
    GenericRequestUpdateParameters params,
  ) => approveGenericRequest(_collectionId, params);

  @override
  Future<Either<Failure, void>> rejectRequest(
    GenericRequestUpdateParameters params,
  ) => rejectGenericRequest(_collectionId, params);

  @override
  Future<Either<Failure, void>> requestChanges(
    GenericRequestUpdateParameters params,
  ) => requestGenericChanges(_collectionId, params);

  @override
  Future<Either<Failure, void>> markRequestAsUpdated(
    GenericRequestUpdateParameters params,
  ) {
    return updateGenericRequest(
      _collectionId,
      params,
      GenericRequestStatus.updated,
      additionalData: {'updatedAt': FieldValue.serverTimestamp()},
    );
  }
}
