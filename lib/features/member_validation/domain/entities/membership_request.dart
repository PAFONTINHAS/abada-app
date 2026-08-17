//solicitação feita pelo usuario e analisada por um prof

import 'membership_request_status.dart';

class MembershipRequest {
  final String id; //id da solicitacao
  final String userId; //id do usuario que vem do cadastro
  final String professorId;//id do prof que o user selecionou
  final MembershipRequestStatus status; //atribuição inicial automárica para pending
  final String rejectionReason; // motivo da rejeição
//definindo os atibutos e seus tipos para usar no constructor

  const MembershipRequest({
    required this.id,
    required this.userId,
    required this.professorId,
    required this.status,
    required this.rejectionReason,
    //constructor
  });
}
