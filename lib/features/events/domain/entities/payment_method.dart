enum PaymentMethod { pix, creditCard, unknown }

extension PaymentMethodExtension on PaymentMethod{

  static PaymentMethod fromString(String status){

    return PaymentMethod.values.firstWhere(
      (e) => e.name.toLowerCase() == status.toLowerCase(),
      orElse: () => PaymentMethod.unknown
    );
  }

  String get displayPortugueseText{
    switch(this){
      case PaymentMethod.pix: return "PIX";
      case PaymentMethod.creditCard: return "Cartão de Crédito";
      case PaymentMethod.unknown: return "Desconhecido";
    }
  }

}