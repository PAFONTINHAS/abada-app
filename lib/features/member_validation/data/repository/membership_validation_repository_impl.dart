import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/requests/data/request_datasource_impl.dart';

import '../../domain/entities/membership_request.dart';
import '../../domain/repository/membership_validation_repostitory.dart';
import '../datasource/membership_validation_remote_datasource.dart';

class MembershipValidationRepositoryImpl
    implements MembershipValidationRepository {
  final MembershipValidationRemoteDataSource remoteDataSource;

  MembershipValidationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<MembershipRequest>>> getProfessorRequests(
    String professorId,
  ) async {
    return await remoteDataSource.getProfessorRequests(professorId);
  }

  @override
  Future<Either<Failure, void>> approveRequest(String requestId) async {
    return await remoteDataSource.approveRequest(
      GenericRequestParameters(requestId: requestId),
    );
  }

  @override
  Future<Either<Failure, void>> requestChanges(
    String requestId,
    String changeReason,
  ) async {
    return await remoteDataSource.requestChanges(
      GenericRequestParameters(
        requestId: requestId,
        changeReason: changeReason,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> rejectRequest(
    String requestId,
    String rejectReason,
  ) async {
    return await remoteDataSource.rejectRequest(
      GenericRequestParameters(
        requestId: requestId,
        rejectionReason: rejectReason,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> markRequestAsUpdated(String requestId) async {
    return await remoteDataSource.markRequestAsUpdated(
      GenericRequestParameters(requestId: requestId),
    );
  }

  @override
  Future<Either<Failure, void>> createMembershipRequest(
    MembershipRequest request,
  ) async {
    return await remoteDataSource.createMembershipRequest(request);
  }
}
