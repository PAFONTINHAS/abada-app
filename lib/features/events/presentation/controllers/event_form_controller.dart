
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/utils/mask_formatter.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/core/services/location_service/place_suggestion.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_products_item.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';

class EventFormController extends ChangeNotifier {
  bool _isInitializing = true;
  bool get isInitializing => _isInitializing;

  String? _initializationError;
  String? get initializationError => _initializationError;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  EventEntity? _eventToEdit;
  bool get isEditing => _eventToEdit != null;
  
  String? _requestId;
  String? get requestId => _requestId;

  GenericRequestStatus? _savedStatus;
  GenericRequestStatus? get savedStatus => _savedStatus;

  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventValueController = TextEditingController();
  final TextEditingController eventLocationController = TextEditingController();
  final TextEditingController eventDescriptionController = TextEditingController();

  EventType _eventType = EventType.UNKNOWN;
  EventType get eventType => _eventType;

  File? _eventImage;
  File? get eventImage => _eventImage;

  String? get existingImageUrl => _eventToEdit?.eventImagePath;

  DateTime? _eventInitDate;
  DateTime? get eventInitDate => _eventInitDate;

  DateTime? _eventEndingDate;
  DateTime? get eventEndingDate => _eventEndingDate;

  PlaceSuggestion? _savedLocation;
  PlaceSuggestion? get savedLocation => _savedLocation;

  bool get isFirstPhaseComplete {
    if (eventNameController.text.trim().isEmpty) return false;
    if (eventLocationController.text.trim().isEmpty) return false;
    return true;
  }

  bool get isSecondPhaseComplete {
    return _eventType != EventType.UNKNOWN;
  }

  void startInitialization() {
    _isInitializing = true;
    _initializationError = null;
    notifyListeners();
  }

  void finishInitialization({String? error}) {
    _initializationError = error;
    _isInitializing = false;
    notifyListeners();
  }

  void setSubmitting(bool value) {
    if (_isSubmitting == value) return;
    _isSubmitting = value;
    notifyListeners();
  } 
  
  void cleanController(){
    _eventToEdit = null;
    _requestId = null;
    _savedStatus = null;
    _eventInitDate = null;
    _eventEndingDate = null;
    _eventImage = null;
  }

  /// Carrega os dados do evento existente para edição e reenvio.
  void beginEditing({
    required EventEntity event,
    required String requestId,
  }) {

    _savedLocation = PlaceSuggestion(
      city: event.city,
      state: event.state,
      osmKey: '',
      latitude: event.latitude,
      district: '',
      longitude: event.longitude,
      fullAddress: event.eventLocation,
    );

    _eventToEdit = event;
    _requestId = requestId;

    eventNameController.text = event.eventName;

    final totalValue = MaskFormatter.convertMoneyStringToDouble(event.eventValue);
    final mandatoryProductsValue = event.products.fold<double>(0, (total, product) => total + (product.mandatory ? product.price : 0));
    final baseValue = totalValue - mandatoryProductsValue;

    eventValueController.text = MaskFormatter.convertMoneyDoubleToString(baseValue);

    eventValueController.text = eventValueController.text == "0.00"
      ? ""
      : eventValueController.text;

    eventDescriptionController.text = event.eventDescription ?? '';
    _eventType = event.eventType;
    _eventInitDate = event.eventInitDate;
    _eventEndingDate = event.eventEndingDate;
    eventLocationController.text = event.eventLocation;


    _eventImage = null;
    notifyListeners();
  }

  void setEventLocation(String value) {
    eventLocationController.text = value;
    notifyListeners();
  }

  void setEventInitDate(DateTime selectedDate, TimeOfDay selectedTime) {
    if (isEditing) return;

    _eventInitDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    notifyListeners();
  }

  void setEventEndingDate(DateTime selectedDate, TimeOfDay selectedTime) {
    if (isEditing) return;

    _eventEndingDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    notifyListeners();
  }

  void setEventType(EventType type) {
    _eventType = type;
    notifyListeners();
  }

  void setEventImage(File? imageFile) {
    if (imageFile == null) return;
    _eventImage = imageFile;
    notifyListeners();
  }

  void removeSelectedImage() {
    _eventImage = null;
    notifyListeners();
  }


  EventEntity? buildUpdatedEventEntity({
    required PlaceSuggestion place,
    required ClassEntity? selectedClass,
    required Set<String> selectedMemberIds,
    required List<EventProductItem> products,
  }){

    if(_eventToEdit == null) return null;

    double totalEventDoubleValue = MaskFormatter.convertMoneyStringToDouble(
      eventValueController.text.trim(),
    );

    for (final product in products) {
      if (product.mandatory) {
        totalEventDoubleValue += product.price;
      }
    }

    final totalEventStringValue = MaskFormatter.convertMoneyDoubleToString(totalEventDoubleValue,);
    final now = DateTime.now();

    return EventEntity(
      city: place.city,
      state: place.state,
      products: products,
      eventType: eventType,
      latitude: place.latitude,
      longitude: place.longitude,
      eventId: _eventToEdit!.eventId,
      eventValue: totalEventStringValue,
      eventInitDate: eventInitDate ?? now,
      eventName: eventNameController.text,
      selectedMembersId: selectedMemberIds,
      selectedClassId: selectedClass?.classId,
      eventEndingDate: eventEndingDate ?? now,
      eventCreatorId: _eventToEdit!.eventCreatorId,
      eventDescription: eventDescriptionController.text,
      eventLocation: eventLocationController.text.trim(),
      eventCreatorNickname: _eventToEdit!.eventCreatorNickname,
    );
  }

  EventEntity? buildEventEntity({
    required String userId,
    required PlaceSuggestion place,
    required String userNickname,
    required ClassEntity? selectedClass,
    required Set<String> selectedMemberIds,
    required List<EventProductItem> products,
  }) {
    double totalEventDoubleValue = MaskFormatter.convertMoneyStringToDouble(
      eventValueController.text.trim(),
    );

    for (final product in products) {
      if (product.mandatory) {
        totalEventDoubleValue += product.price;
      }
    }

    final totalEventStringValue = MaskFormatter.convertMoneyDoubleToString(totalEventDoubleValue,);
    final now = DateTime.now();

    return EventEntity(
      eventId: '',
      city: place.city,
      products: products,
      state: place.state,
      eventType: eventType,
      eventCreatorId: userId,
      latitude: place.latitude,
      longitude: place.longitude,
      eventName: eventNameController.text.trim(),
      eventCreatorNickname:  userNickname,
      eventValue: totalEventStringValue,
      eventInitDate: eventInitDate ?? now,
      selectedMembersId: selectedMemberIds,
      eventLocation: eventLocationController.text.trim(),
      eventEndingDate: eventEndingDate ?? now,
      selectedClassId: selectedClass?.classId,
      eventDescription: eventDescriptionController.text.trim(),
    );
  }

  void reset() {
    _eventToEdit = null;
    _requestId = null;

    eventNameController.clear();
    eventValueController.clear();
    eventLocationController.clear();
    eventDescriptionController.clear();

    _eventType = EventType.UNKNOWN;
    _eventImage = null;
    _eventInitDate = null;
    _eventEndingDate = null;

    _isInitializing = true;
    _initializationError = null;
    _isSubmitting = false;

    notifyListeners();
  }

  @override
  void dispose() {
    eventNameController.dispose();
    eventValueController.dispose();
    eventLocationController.dispose();
    eventDescriptionController.dispose();
    super.dispose();
  }
}
