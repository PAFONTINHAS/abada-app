//esse arquivo implementa o repository do domain que é contrato
//é ponte entre o domain e o data. é um garçom
import '../../domain/entities/membership_request.dart';
import '../../domain/repository/membership_validation_repostitory.dart';
import '../datasource/membership_validation_remote_datasource.dart';

class MembershipValidationRepositoryImpl
    implements MembershipValidationRepository {
  final MembershipValidationRemoteDataSource remoteDataSource;

  MembershipValidationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MembershipRequest>> getProfessorRequests(String professorId,
  ) {
    return remoteDataSource.getProfessorRequests(professorId);
    //pede ao remoteDataSource a lista de solicitações a partir do id q eu dei
  }

  @override
  Future<void> approveRequest(String requestId) {
    return remoteDataSource.approveRequest(requestId);
    //pede ao remoteDataSource para aprovar a solicitação a partir do id q eu dei
  }

  @override
  Future<void> requestChanges(String requestId,String changeReason,
  ) {
    return remoteDataSource.requestChanges(requestId,changeReason,
    //pede ao remoteDataSource para atualizar o status da solicitação 
    //para requestChanges a partir do id e do motivo q eu dei
    );
  }

  @override
  Future<void> rejectRequest(String requestId,String rejectReason,
  ) {
    return remoteDataSource.rejectRequest(requestId,rejectReason,
    //pede ao remoteDataSource para rejeitar a solicitação a partir do id e do motivo q eu dei
    );
  }

  @override
  Future<void> markRequestAsUpdated(String requestId,
  ) {
    return remoteDataSource.markRequestAsUpdated(requestId);
    //pede ao remoteDataSource para atualizar a solicitação a partir do id q eu dei
  }
}