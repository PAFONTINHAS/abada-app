//executa uma ação específica do ator, declarado no repository
//representa uma regra de negócio

import '../entities/membership_request.dart';
import '../repository/membership_validation_repostitory.dart';

//busca todas as solicitações de um professor para ele fazer outra ação
class GetProfessorMembershipRequests {
  //cria a classe

  final MembershipValidationRepository repository;
  //cria uma variavel chamada repository do tipo MembershipValidationRepository

  GetProfessorMembershipRequests(this.repository);
  //constructor da classe, recebe as variaveis definidas

  Future<List<MembershipRequest>> call(String professorId) {
    //metodo call localiza quem é o prof atraves do id dele
    //Future<List<MembershipRequest>> é o tipo do retorno, uma lista de solicitações 
    //que chegará no futuro (pq buscar no firebase/api/banco demora)
    
    return repository.getProfessorRequests(professorId);
    //retornando todas as solicitações
  }
}
//GetProfessorMembershipRequests recebe o ID de um professor,
//usa o repository para buscar as solicitações associadas a ele 
//e devolve uma lista de MembershipRequest.