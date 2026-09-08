// quais operações podem ser realizadas pelo ator - PROF
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/membership_request.dart';

abstract class MembershipValidationRepository {

  Future<Either<Failure, List<MembershipRequest>>> getProfessorRequests(String professorId, );
    //busca as solicitações de vínculo do professor -> ver solicitações
    //status = pending ou updated -> não altera status
    //se der certo, retorne a lista de membros
    //se der errado, retorne o erro

  Future<Either<Failure, void>> approveRequest(String requestId,);
    //aprova a solicitação de vínculo dado que apelido e corda = correto
    //status = pending or updated ->  status = approved

  Future<Either<Failure, void>> requestChanges(String requestId, String changeReason,);
    //solicita correção para o membro, corda ou apelido = !correto
    //status = pending -> status = changesRequested
    
  Future<Either<Failure, void>> rejectRequest(String requestId, String rejectionReason, );
    //recusa definitiva a solicitação, membro = !ABADA. motivo recusa é obrigatorio
    //status = pending -> status = rejected

  Future<Either<Failure, void>> markRequestAsUpdated(String requestId,);
    //ação que informa que o membro fez as correções
    //e que a solicitação deve voltar para o prof
    
}