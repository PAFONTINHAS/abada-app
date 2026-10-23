enum EventPhases {
  firstPhase,
  secondPhase,
  thirdPhase,
  fourthPhase,
}

extension EventPhasesExtension on EventPhases{

  int get phaseNumber{
    switch(this){
      case EventPhases.firstPhase: return 1;
      case EventPhases.secondPhase: return 2;
      case EventPhases.thirdPhase: return 3;
      case EventPhases.fourthPhase: return 4;
    }
  }

  EventPhases get nextPhase{
    switch(this){
      case EventPhases.firstPhase: return EventPhases.secondPhase;
      case EventPhases.secondPhase: return EventPhases.thirdPhase;
      case EventPhases.thirdPhase: return EventPhases.fourthPhase;
      case EventPhases.fourthPhase: return EventPhases.firstPhase;
    }
  }
 
  EventPhases get previousPhase{
    switch(this){
      case EventPhases.firstPhase: return EventPhases.firstPhase;
      case EventPhases.secondPhase: return EventPhases.firstPhase;
      case EventPhases.thirdPhase: return EventPhases.secondPhase;
      case EventPhases.fourthPhase: return EventPhases.thirdPhase;
    }
  }
}