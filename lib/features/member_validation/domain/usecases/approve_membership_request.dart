//executa uma ação específica do ator, declarado no repository
//representa uma regra de negócio

import '../repository/membership_validation_repostitory.dart';

class ApproveMembershipRequest {
  //aprova uma solicitação de vinculo quando apelido e corda = corretos
  //finaliza o processo de solicitação

  final MembershipValidationRepository repository;
  //cria uma variavel chamada repository do tipo MembershipValidationRepository

  ApproveMembershipRequest(this.repository);
  //constructor da classe, recebe as variaveis definidas

  Future<void> call(String requestId) {
    //nao retorna nenhum dado do banco, é só ida, não volta
    return repository.approveRequest(requestId);
  }
}
