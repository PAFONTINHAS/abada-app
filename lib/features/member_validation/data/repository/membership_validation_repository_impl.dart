//esse arquivo implementa o repository do domain que é contrato
//é ponte entre o domain e o data. é um garçom
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/membership_request.dart';
import '../../domain/repository/membership_validation_repostitory.dart';
import '../datasource/membership_validation_remote_datasource.dart';

class MembershipValidationRepositoryImpl implements MembershipValidationRepository {
  final MembershipValidationRemoteDataSource remoteDataSource;

  MembershipValidationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<MembershipRequest>>> getProfessorRequests(
        //pede ao remoteDataSource a lista de solicitações a partir do id q eu dei
    String professorId,
  ) async {
      return await remoteDataSource.getProfessorRequests(
        professorId,
      );
  }


  @override
  Future<Either<Failure, void>> approveRequest(String requestId,
     //pede ao remoteDataSource para aprovar a solicitação a partir do id q eu dei
  ) async {
  return await remoteDataSource.approveRequest(requestId);
}

  @override
  Future<Either<Failure, void>> requestChanges(String requestId, String changeReason
      //pede ao remoteDataSource para atualizar o status da solicitação
      //para requestChanges a partir do id e do motivo q eu dei
    ) async {
  return await remoteDataSource.requestChanges(
    requestId,
    changeReason,
  );
}

  @override
  Future<Either<Failure, void>> rejectRequest(String requestId, String rejectReason
      //pede ao remoteDataSource para rejeitar a solicitação a partir do id e do motivo q eu dei
  ) async {
  // Pede ao remoteDataSource para rejeitar a solicitação.
  return await remoteDataSource.rejectRequest(
    requestId,
    rejectReason,
  );
}


  @override
  Future<Either<Failure, void>> markRequestAsUpdated(String requestId
    //pede ao remoteDataSource para atualizar a solicitação a partir do id q eu dei
  ) async {
  // Pede ao remoteDataSource para marcar a solicitação como atualizada.
  return await remoteDataSource.markRequestAsUpdated(
    requestId,
  );
}
}