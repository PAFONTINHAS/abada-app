//status do membro

enum MembershipRequestStatus {
  requested, //cadastrado e pendente
  changesRequested, //prof pediu ajustes
  updated, //membro corrigiu
  approved, //prof aprovou
  rejected, //prof recusou
}

extension MembershipRequestStatusExtension on MembershipRequestStatus{

  String get portugueseName {

    switch(this){
      case MembershipRequestStatus.updated: return 'Atualizado';
      case MembershipRequestStatus.requested: return 'Solicitado';
      case MembershipRequestStatus.approved: return 'Aprovado';
      case MembershipRequestStatus.rejected: return 'Rejeitado';
      case MembershipRequestStatus.changesRequested: return 'Alterações Solicitadas';
    }
  }
}