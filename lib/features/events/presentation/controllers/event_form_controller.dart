import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/utils/mask_formatter.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_products_item.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/create_event_request_usecase.dart';

class EventFormController extends ChangeNotifier{

  final CreateEventRequestUsecase _createEventRequestUsecase;

  EventFormController(this._createEventRequestUsecase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  TextEditingController eventName = TextEditingController();
  TextEditingController eventValue = TextEditingController();
  TextEditingController eventLocation = TextEditingController();
  TextEditingController eventDescription = TextEditingController();

  bool get isFirstPhaseComplete{

    if(eventName.text.trim().isEmpty) return false;
    if(eventLocation.text.trim().isEmpty) return false;

    return true;
  }
  
  bool get isSecondPhaseComplete{
    return _eventType != EventType.UNKNOWN;
  }

  EventType _eventType = EventType.UNKNOWN;
  EventType get eventType => _eventType;

  File? _eventImage;
  File? get eventImage => _eventImage;

  DateTime? _eventInitDate;
  DateTime? get eventInitDate => _eventInitDate;

  DateTime? _eventEndingDate;
  DateTime? get eventEndingDate => _eventEndingDate;


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
      selectedTime.minute
    );

    notifyListeners();
  }

  void setEventEndingDate(DateTime selectedDate, TimeOfDay selectedTime){
    _eventEndingDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute
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

  EventEntity? buildEventEntity({
    required List<EventProductItem> products,
    required String userId,
    required String userNickname,
    required Set<String> selectedMemberIds,
    required ClassEntity? selectedClass
  }) {
    double totalEventDoubleValue = MaskFormatter.convertMoneyStringToDouble(
      eventValue.text.trim(),
    );

    for (final product in products) {
      if (product.mandatory) {
        totalEventDoubleValue += product.price;
      }
    }

    String totalEventStringValue = MaskFormatter.convertMoneyDoubleToString(
      totalEventDoubleValue,
    );

    final now = DateTime.now();

    return EventEntity(
      eventId: '',
      products: products,
      finishedEvent: false,
      eventType: eventType,
      eventCreatorId: userId,
      eventName: eventName.text.trim(),
      eventCreatorNickname: userNickname,
      eventValue: totalEventStringValue,
      eventInitDate: eventInitDate ?? now,
      selectedMembersId: selectedMemberIds,
      eventLocation: eventLocation.text.trim(),
      eventEndingDate: eventEndingDate ?? now,
      selectedClassId: selectedClass?.classId,
      eventDescription: eventDescription.text.trim(),
    );
  }

  Future<bool> createEventRequest(EventEntity event) async{

    _isLoading = true;
    notifyListeners();

    final result = await _createEventRequestUsecase.call(event, _eventImage);

    final bool success = result.fold((failure){
      _errorMessage = failure.message;
      return false;
    }, (requestedEvent){

      return true;
    });

    _isLoading = false;

    notifyListeners();
    return success;
  }

}