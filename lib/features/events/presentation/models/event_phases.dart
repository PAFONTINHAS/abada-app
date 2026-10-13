enum EventPhases {
  firstPhase,
  secondPhase,
  thirdPhase,
}

extension EventPhasesExtension on EventPhases{
  EventPhases get nextPhase{
    switch(this){
      case EventPhases.firstPhase: return EventPhases.secondPhase;
      case EventPhases.secondPhase: return EventPhases.thirdPhase;
      case EventPhases.thirdPhase: return EventPhases.firstPhase;
    }
  }
 
  EventPhases get previousPhase{
    switch(this){
      case EventPhases.firstPhase: return EventPhases.firstPhase;
      case EventPhases.secondPhase: return EventPhases.firstPhase;
      case EventPhases.thirdPhase: return EventPhases.secondPhase;
    }
  }
}