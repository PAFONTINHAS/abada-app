import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';

class CreateEventRequestUsecaseValidator {

  CreateEventRequestUsecaseValidator._();

  static String? validate(EventEntity event){

    bool invalidDate = event.eventInitDate.isAtSameMomentAs(event.eventEndingDate);

    bool isGraduationEvent = event.eventType.isGraduationEvent;

    bool validGraduationEvent =      
        event.selectedClassId != null &&
        (event.selectedMembersId != null && event.selectedMembersId!.isNotEmpty);

    if(event.eventName.isEmpty) return "Campo de nome não pode ser vazio";
    if(invalidDate) return "Data inválida";
    if(isGraduationEvent && !validGraduationEvent) return "Revise os requisitos para iniciar um evento de graduação";


    return null;
  }

}