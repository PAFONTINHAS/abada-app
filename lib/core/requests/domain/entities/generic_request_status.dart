enum GenericRequestStatus {
  requested, //cadastrado e pendente
  changesRequested, //prof pediu ajustes
  updated, //membro corrigiu
  approved, //prof aprovou
  rejected, //prof recusou
}

extension GenericRequestStatusExtension on GenericRequestStatus{

  String get portugueseName {

    switch(this){
      case GenericRequestStatus.updated: return 'Atualizado';
      case GenericRequestStatus.requested: return 'Solicitado';
      case GenericRequestStatus.approved: return 'Aprovado';
      case GenericRequestStatus.rejected: return 'Rejeitado';
      case GenericRequestStatus.changesRequested: return 'Alterações Solicitadas';
    }
  }
}