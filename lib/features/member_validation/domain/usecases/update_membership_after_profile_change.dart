import '../entities/membership_request.dart';
import '../entities/membership_request_status.dart';
import '../repository/membership_validation_repostitory.dart';

class UpdateMembershipAfterProfileChange {
  //verifica se uma alteração no perfil deve fazer a solicitação voltar para o professor.
  final MembershipValidationRepository repository;

  UpdateMembershipAfterProfileChange(this.repository);

  Future<void> call({
    //parametros nomeados, precisa escrever o nome do parametro ao chamar
    // request: request,
    // nicknameChanged: true,
    // beltChanged: false,
    required MembershipRequest request,
    required bool nicknameChanged,
    required bool beltChanged,
    //ele sabe que é true ou false quando alguem chamar ele e passar o valor
  })
  async {
    //diz que existe um await para esperar a operação async terminar
    // A solicitação só volta para análise quando:
    // 1. o professor solicitou mudanças;
    // 2. o membro alterou a corda e/ou o apelido.
    
    if (request.status == MembershipRequestStatus.changesRequested &&
      //se o status da solicitação estiver em changesRequest, ou seja, se prof pediu correção
      // E
      (nicknameChanged || beltChanged)) {
      // tiver mudado o apelido ou a corda = 1 true

      await repository.markRequestAsUpdated(request.id);
    //chama o repositorio para pegar o id da solicitação 
    //para tudo e executa isso pq eu preciso dessa info agora, virou prioridade
    // e nao faça nada enquanto nao tiver essa info
    //só depois da info (id)= marcar status = updated
    }
  }
}
