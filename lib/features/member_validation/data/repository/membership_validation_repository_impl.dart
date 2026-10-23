import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_update_parameters.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/membership_request.dart';
import '../datasource/membership_validation_remote_datasource.dart';
import '../../domain/repository/membership_validation_repostitory.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_creation_parameters.dart';

class MembershipValidationRepositoryImpl implements MembershipValidationRepository {
  final MembershipValidationRemoteDataSource remoteDataSource;

  MembershipValidationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<MembershipRequest>>> getProfessorRequests(String professorId) async {
    return await remoteDataSource.getProfessorRequests(professorId);
  }

  @override
  Future<Either<Failure, void>> approveRequest(String requestId) async {
    return await remoteDataSource.approveRequest(
      GenericRequestUpdateParameters(requestId: requestId),
    );
  }

  @override
  Future<Either<Failure, void>> requestChanges(String requestId, String changeReason) async {
    return await remoteDataSource.requestChanges(
      GenericRequestUpdateParameters(
        requestId: requestId,
        changeReason: changeReason,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> rejectRequest(String requestId, String rejectReason) async {
    return await remoteDataSource.rejectRequest(
      GenericRequestUpdateParameters(
        requestId: requestId,
        rejectionReason: rejectReason,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> markRequestAsUpdated(String requestId) async {
    return await remoteDataSource.markRequestAsUpdated(
      GenericRequestUpdateParameters(requestId: requestId),
    );
  }

  @override
  Future<Either<Failure, void>> createMembershipRequest(MembershipRequest request) async {
    return await remoteDataSource.createMembershipRequest(request);
  }
}
