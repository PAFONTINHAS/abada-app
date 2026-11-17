enum GenericRequestStatus {
  requested, //cadastrado e pendente
  changesRequested, //prof pediu ajustes
  updated, //membro corrigiu
  approved, //prof aprovou
  rejected, //prof recusou
  unknow // o sistema nao conseguiu identificar o status
}

class GenericRequestStatusExtension{
  GenericRequestStatusExtension._();
  //construtor privado, impede que outras partes do app criem objetos dessa classe,


  static GenericRequestStatus fromString(String status){

    switch(status){
      //recebe status como texto e retorna como valor o status do enum 
      //centraliza a conversao para que nao precise replicar essa logica em cada datasource (dtsc nao sabe qual é o status até ele ser convertido)
      case 'updated': return GenericRequestStatus.updated;
      case 'approved': return GenericRequestStatus.approved;
      case 'rejected': return GenericRequestStatus.rejected;
      case 'requested': return GenericRequestStatus.requested;
      case 'changesRequested': return GenericRequestStatus.changesRequested;
      default: return GenericRequestStatus.unknow;
    }
  }
}

//extensão do enum, recebe um valor de status do enum e retorna para impressao em pt
//modularização
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