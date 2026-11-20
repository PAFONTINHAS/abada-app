enum SubscriptionStatus { subscribed, confirmed, canceled, unknown }


extension SubscriptionStatusExtension on SubscriptionStatus{

  static SubscriptionStatus fromString(String status){

    return SubscriptionStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == status.toLowerCase(),
      orElse: () => SubscriptionStatus.unknown
    );
  }

  String get displayPortugueseText{
    switch(this){
      case SubscriptionStatus.canceled: return "Cancelado";
      case SubscriptionStatus.subscribed: return "Inscrito";
      case SubscriptionStatus.confirmed: return "Confirmado";
      case SubscriptionStatus.unknown: return "Desconhecido";
    }

  }

}