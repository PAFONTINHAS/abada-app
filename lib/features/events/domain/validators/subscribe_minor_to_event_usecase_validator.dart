import 'package:sistema_abada_capoeira/features/events/domain/entities/event_subscription_entity.dart';

class SubscribeMinorToEventUsecaseValidator {

  SubscribeMinorToEventUsecaseValidator._();


  static String? validate(EventSubscriptionEntity subscription){

    final minorSubscriptionData = subscription.minorStudentSubscriptionData;

    if(minorSubscriptionData == null) return "Dados do menor não podem ser vazio";

    final bool studentOnlyFirstName = minorSubscriptionData.studentFullName.split(" ").length == 1;
    final bool guardianOnlyFirstName = minorSubscriptionData.legalGuardianName.split(" ").length == 1;

    if(minorSubscriptionData.studentFullName.isEmpty) return "Insira o nome do aluno";

    if(minorSubscriptionData.studentCurrentBelt.isEmpty) return "Insira a corda do aluno";
    
    if(minorSubscriptionData.legalGuardianName.isEmpty) return "Insira o nome do responsável legal";

    if(minorSubscriptionData.legalGuardianPhoneNumber.isEmpty) return "Insira o telefone do responsável legal";
    
    if(!minorSubscriptionData.hasLegalGuardianConsent) return "Registros não podem ser feitos sem autorização prévia do responsável";

    if(studentOnlyFirstName) return "Insira o nome completo do aluno";
    if(guardianOnlyFirstName) return "Insira o nome completo do responsável legal";
  
    return null;

  }

}