import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/membership_request.dart';
import '../entities/membership_request_status.dart';
import '../repository/membership_validation_repostitory.dart';

class UpdateMembershipAfterProfileChange {
  //verifica se uma alteração no perfil deve fazer a solicitação voltar para o professor.
  final MembershipValidationRepository repository;

  UpdateMembershipAfterProfileChange(this.repository);

  Future<Either<Failure, void>> call({
    required MembershipRequest request,
    required bool nicknameChanged,
    required bool beltChanged,
    //ele sabe que é true ou false quando alguem chamar ele e passar o valor
  }) async {

    if (request.status == MembershipRequestStatus.changesRequested && (nicknameChanged || beltChanged)) {
        //se o status da solicitação estiver em changesRequest, ou seja, se prof pediu correção e tiver mudado o apelido ou a corda = 1 true

      return await repository.markRequestAsUpdated(request.id);
      //chama o repositorio para pegar o id da solicitação
      //para tudo e executa e depois da info (id)= marcar status = updated
    }
    return const Right(null);
  }
  //Quando há uma correção relevante, o use case chama o repository e devolve o resultado.
  //Quando não há nada para atualizar, retorna Right(unit), indicando que a operação terminou sem erro.
}
