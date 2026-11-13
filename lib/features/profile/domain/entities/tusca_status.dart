enum TuscaStatus { 
  regular, 
  exempt, 
  pending, 
  notApplicable,
  unknown
}

extension TuscaStatusExtended on TuscaStatus{

  bool get isValidTusca{
    
    return this == TuscaStatus.regular || this == TuscaStatus.exempt;
  }

  bool get notApplicable{

    return this == TuscaStatus.notApplicable;
  }

}

class TuscaStatusExtension{
  TuscaStatusExtension._();

  static TuscaStatus fromString(String tuscaStatus){

    switch(tuscaStatus){
      case "regular": return TuscaStatus.regular;
      case "pending": return TuscaStatus.pending;
      case "exempt" : return TuscaStatus.exempt;
      case "notApplicable": return TuscaStatus.notApplicable;
      default: return TuscaStatus.unknown;
    }
  }

  static String toPortuguese(TuscaStatus status) {
    const labels = {
      TuscaStatus.regular: 'REGULAR',
      TuscaStatus.pending: 'PENDENTE',
      TuscaStatus.exempt: 'ISENTO',
      TuscaStatus.notApplicable: 'NÃO APLICÁVEL',
    };
    return labels[status] ?? 'NÃO APLICÁVEL';
  }
}