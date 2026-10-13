import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/models/event_phases.dart';

class EventFormPhasesController extends ChangeNotifier{

  EventPhases _currentPhase = EventPhases.firstPhase;
  EventPhases get currentPhase => _currentPhase;

  void nextFormPhase(){

    _currentPhase = _currentPhase.nextPhase;
     
    notifyListeners();
  }
}