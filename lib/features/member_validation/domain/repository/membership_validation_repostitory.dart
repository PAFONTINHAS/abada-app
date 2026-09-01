// quais operações podem ser realizadas pelo ator - PROF
import '../entities/membership_request.dart';

abstract class MembershipValidationRepository {

  Future<List<MembershipRequest>> getProfessorRequests(String professorId, );
    //busca as solicitações de vínculo do professor -> ver solicitações
    //status = pending ou updated -> não altera status

  Future<void> approveRequest(String requestId,);
    //aprova a solicitação de vínculo dado que apelido e corda = correto
    //status = pending or updated ->  status = approved

  Future<void> requestChanges(String requestId, String changeReason,);
    //solicita correção para o membro, corda ou apelido = !correto
    //status = pending -> status = changesRequested
    
  Future<void> rejectRequest(String requestId, String rejectionReason, );
    //recusa definitiva a solicitação, membro = !ABADA. motivo recusa é obrigatorio
    //status = pending -> status = rejected

    Future<void> markRequestAsUpdated(String requestId,);
    //ação que informa que o membro fez as correções
    //e que a solicitação deve voltar para o prof
    
}