import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';

class EventFormController extends ChangeNotifier{

  TextEditingController eventName = TextEditingController();
  TextEditingController eventValue = TextEditingController();
  TextEditingController eventLocation = TextEditingController();
  TextEditingController eventDescription = TextEditingController();

  EventType _eventType = EventType.COMPETITION;
  EventType get eventType => _eventType;

  File? _eventImage;
  File? get eventImage => _eventImage;

  DateTime? _eventInitDate;
  DateTime? get eventInitDate => _eventInitDate;

  DateTime? _eventEndingTime;
  DateTime? get eventEndingTime => _eventEndingTime;
  

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
    _eventEndingTime = DateTime(
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