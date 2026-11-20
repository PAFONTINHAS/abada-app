enum EventRequestType{
  creation,
  cancelation
}


extension EventRequestTypeExtension on EventRequestType{

  bool get isCreationRequest => this == EventRequestType.creation;
  bool get isCancelationRequest => this == EventRequestType.cancelation;

  static EventRequestType fromString(String? type){
    switch(type){
      case 'creation': return EventRequestType.creation;
      case 'cancelation': return EventRequestType.cancelation;
      default: return EventRequestType.creation; 
    }
  }

  String get portugueseName{

    switch(this){
      case EventRequestType.creation: return "CRIAÇÃO DE EVENTO";
      case EventRequestType.cancelation: return "CANCELAMENTO DE EVENTO";
    }

  }

}