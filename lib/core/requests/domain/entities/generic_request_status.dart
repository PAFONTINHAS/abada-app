enum GenericRequestStatus {
  requested, //cadastrado e pendente
  changesRequested, //prof pediu ajustes
  updated, //membro corrigiu
  approved, //prof aprovou
  rejected, //prof recusou
  unknow
}


class GenericRequestStatusExtension{
  GenericRequestStatusExtension._();


  static GenericRequestStatus fromString(String status){

    switch(status){
      case 'updated': return GenericRequestStatus.updated;
      case 'approved': return GenericRequestStatus.approved;
      case 'rejected': return GenericRequestStatus.rejected;
      case 'requested': return GenericRequestStatus.requested;
      case 'changesRequested': return GenericRequestStatus.changesRequested;
      default: return GenericRequestStatus.unknow;
    }
  }
}

extension GenericRequestStatusExt on GenericRequestStatus{

  String get portugueseName {

    switch(this){
      case GenericRequestStatus.updated: return 'Atualizado';
      case GenericRequestStatus.requested: return 'Solicitado';
      case GenericRequestStatus.approved: return 'Aprovado';
      case GenericRequestStatus.rejected: return 'Rejeitado';
      case GenericRequestStatus.changesRequested: return 'Alterações Solicitadas';
      case GenericRequestStatus.unknow: return 'Desconhecido';
    }
  }
}