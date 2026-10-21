import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';

class EventFormController extends ChangeNotifier{

  TextEditingController eventName = TextEditingController();
  TextEditingController eventValue = TextEditingController();
  TextEditingController eventLocation = TextEditingController();
  TextEditingController eventDescription = TextEditingController();

  bool get isFirstPhaseComplete{

    if(eventName.text.trim().isEmpty) return false;
    if(eventLocation.text.trim().isEmpty) return false;
    if(eventDescription.text.trim().isEmpty) return false;

    return true;
  }
  
  bool get isSecondPhaseComplete{
    return _eventType != EventType.UNKNOWN;
  }

  bool get isGraduationPhaseComplete{
    return _selectedMemberIds.isNotEmpty;
  }

  EventType _eventType = EventType.UNKNOWN;
  EventType get eventType => _eventType;

  File? _eventImage;
  File? get eventImage => _eventImage;

  DateTime? _eventInitDate;
  DateTime? get eventInitDate => _eventInitDate;

  DateTime? _eventEndingDate;
  DateTime? get eventEndingDate => _eventEndingDate;

  ClassEntity? _selectedClass;
  ClassEntity? get selectedClass => _selectedClass;

  // Armazena os IDs dos alunos selecionados para graduação
  final Set<String> _selectedMemberIds = {};
  Set<String> get selectedMemberIds => _selectedMemberIds;

  void selectClass(ClassEntity? classEntity) {
    _selectedClass = classEntity;
    _selectedMemberIds.clear(); // Limpa a seleção ao trocar de turma
    notifyListeners();
  }

  void toggleMemberSelection(String memberId) {
    if (_selectedMemberIds.contains(memberId)) {
      _selectedMemberIds.remove(memberId);
    } else {
      _selectedMemberIds.add(memberId);
    }
    notifyListeners();
  }

  void toggleSelectAllMembers() {
    if (_selectedClass == null) return;
    
    if (_selectedMemberIds.length == _selectedClass!.members.length) {
      _selectedMemberIds.clear();
    } else {
      _selectedMemberIds.addAll(_selectedClass!.members.map((m) => m.studentId));
    }
    notifyListeners();
  }
    

  void setEventLocation(String value){
    eventLocation.text = value;

    notifyListeners();
  }

  void setEventInitDate(DateTime selectedDate, TimeOfDay selectedTime){
    _eventInitDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedDate.minute
    );

    notifyListeners();
  }

  void setEventEndingDate(DateTime selectedDate, TimeOfDay selectedTime){
    _eventEndingDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedDate.minute
    );

    notifyListeners();
  }

  void setEventType(EventType type){

    _eventType = type;

    notifyListeners();
  }

  void setEventImage(File? imageFile){

    if(imageFile == null) return;

    _eventImage = imageFile;

    notifyListeners();
  }

  void removeSelectedImage(){

    _eventImage = null;
    notifyListeners();
  }
  

}