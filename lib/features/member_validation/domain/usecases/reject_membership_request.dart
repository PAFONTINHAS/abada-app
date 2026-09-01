//executa uma ação específica do ator, declarado no repository
//representa uma regra de negócio
import '../repository/membership_validation_repostitory.dart';

class RejectMembershipRequest {
  //rejeita a solicitação do membro defenitivamente, motivo da recusa é obrigatorio
  //encerra a solicitaçã, status = reject

  final MembershipValidationRepository repository;
  //cria uma variavel chamada repository do tipo MembershipValidationRepository

  RejectMembershipRequest(this.repository);
  //constructor da classe, recebe as variaveis definidas

  Future<void> call(String requestId, String rejectionReason) {
    //recebe como parametro requestId e o motivo para a alteração
    //nao retorna nada pq é uma ação de apenas ida

    if (rejectionReason.trim().isEmpty) {
      //validação caso o prof não informe o motivo que é obrigatório
      throw ArgumentError('O motivo da rejeição é obrigatório');
    }

    return repository.rejectRequest(requestId, rejectionReason);
    //mas retoma a ação
  }
}
