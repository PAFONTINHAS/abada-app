//executa uma ação específica do ator, declarado no repository
//representa uma regra de negócio
import '../repository/membership_validation_repostitory.dart';

class RequestMembershipChanges {
  //solicita correção do membro, apelido ou corda =!correto
  //motivo da correção é obrigatorio
  //status = changesRequest enquanto aguarda o update
  
  final MembershipValidationRepository repository;
  //cria uma variavel chamada repository do tipo MembershipValidationRepository

  RequestMembershipChanges(this.repository);
  //constructor da classe, recebe as variaveis definidas

  Future<void> call(String requestId, String changeReason) {
    //parametros posicionais, chamar em ordem
    //recebe como parametro requestId e o motivo para a alteração
    //nao retorna nada pq é uma ação de apenas ida

    if (changeReason.trim().isEmpty) {
      //validação caso o prof não informe o motivo que é obrigatório
      throw ArgumentError('O motivo da alteração é obrigatório.',);
    }

    return repository.requestChanges(requestId, changeReason);
  //mas retoma a ação
  }
}
