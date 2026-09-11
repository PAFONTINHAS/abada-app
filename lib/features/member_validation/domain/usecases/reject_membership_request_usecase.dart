//executa uma ação específica do ator, declarado no repository
//representa uma regra de negócio
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repository/membership_validation_repostitory.dart';

class RejectMembershipRequestUsecase {
  //rejeita a solicitação do membro defenitivamente, motivo da recusa é obrigatorio
  //encerra a solicitaçã, status = reject

  final MembershipValidationRepository repository;
  //cria uma variavel chamada repository do tipo MembershipValidationRepository

  RejectMembershipRequestUsecase(this.repository);
  //constructor da classe, recebe as variaveis definidas

  Future<Either<Failure, void>> call(String requestId, String rejectionReason) async {
    //recebe como parametro requestId e o motivo para a alteração
    //nao retorna nada pq é uma ação de apenas ida

    if (rejectionReason.trim().isEmpty) {
      //validação caso o prof não informe o motivo que é obrigatório
      return const Left(
        ValidationFailure('O motivo da rejeição é obrigatório.'),
      );
    }

    return await repository.rejectRequest(requestId, rejectionReason);
    //mas retoma a ação
  }
}
