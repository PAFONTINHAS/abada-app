import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';

class CreateEventRequestUsecaseValidator {

  CreateEventRequestUsecaseValidator._();

  static String? validate(EventEntity event){

    bool invalidDate = event.eventInitDate.isAtSameMomentAs(event.eventEndingDate);

    bool validGraduationEvent =
      event.eventType.isGraduationEvent &&
        (
          event.selectedClassId != null &&
          (event.selectedMembersId != null && event.selectedMembersId!.isNotEmpty)
        ); 

    if(event.eventName.isEmpty) return "Campo de nome não pode ser vazio";
    if(invalidDate) return "Data inválida";
    if(!validGraduationEvent) return "Revise os requisitos para iniciar um evento de graduação";


    return null;
  }

}