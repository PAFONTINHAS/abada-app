//ignore_for_file: constant_identifier_names

enum EventType {
  GRADUATION,
  COMPETITION,
  UNKNOWN
}

extension EventTypeExt on EventType{

  bool get isGraduationEvent{
    return this == EventType.GRADUATION;
  }

  bool get isCompetitionEvent{
    return this == EventType.COMPETITION;
  }

  
}

class EventTypeExtension{

  EventTypeExtension._();

  static EventType getFromString(String eventType){

    switch(eventType){

      case 'GRADUAÇÃO': return EventType.GRADUATION;
      case 'COMPETIÇÃO': return EventType.COMPETITION; 
      default: return EventType.UNKNOWN;
    }
  }

  static String convertToUIText(EventType eventType){

    switch(eventType){

      case EventType.GRADUATION:  return 'GRADUAÇÃO';
      case EventType.COMPETITION: return 'COMPETIÇÃO';
      case EventType.UNKNOWN:     return 'DESCONHECIDO';
    }

  }

  static EventType fromString(String type){

    switch(type){
      case 'GRADUATION': return EventType.GRADUATION;
      case 'COMPETITION': return EventType.COMPETITION;
      default: return EventType.UNKNOWN;
    }
  }



}