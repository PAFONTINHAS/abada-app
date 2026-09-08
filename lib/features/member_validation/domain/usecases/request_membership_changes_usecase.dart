//executa uma ação específica do ator, declarado no repository
//representa uma regra de negócio
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repository/membership_validation_repostitory.dart';

class RequestMembershipChanges {
  //solicita correção do membro, apelido ou corda =!correto
  //motivo da correção é obrigatorio
  //status = changesRequest enquanto aguarda o update

  final MembershipValidationRepository repository;
  //cria uma variavel chamada repository do tipo MembershipValidationRepository

  RequestMembershipChanges(this.repository);
  //constructor da classe, recebe as variaveis definidas

  Future<Either<Failure, void>> call(
    String requestId,
    String changeReason,
  ) async {
    //parametros posicionais, chamar em ordem
    //recebe como parametro requestId e o motivo para a alteração
    //nao retorna nada pq é uma ação de apenas ida

    if (changeReason.trim().isEmpty) {
      //validação caso o prof não informe o motivo que é obrigatório
      return const Left(
        ValidationFailure('O motivo da alteração é obrigatório.'),
      );
    }

    return await repository.requestChanges(requestId, changeReason);
    //mas retoma a ação
  }
}
