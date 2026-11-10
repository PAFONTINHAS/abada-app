<<<<<<< HEAD

=======
>>>>>>> 705d01ed6c6960a205e9f598933b4d4d4778fceb
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/utils/mask_formatter.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_products_item.dart';
<<<<<<< HEAD
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';
=======
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/create_event_request_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/resubmit_event_request_usecase.dart';
>>>>>>> 705d01ed6c6960a205e9f598933b4d4d4778fceb

class EventFormController extends ChangeNotifier {
  bool _isInitializing = true;
  bool get isInitializing => _isInitializing;

  String? _initializationError;
  String? get initializationError => _initializationError;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  EventEntity? _originalEvent;
  bool get isEditing => _originalEvent != null;
  
  String? _requestId;
<<<<<<< HEAD
=======
  String? get requestId => _requestId;

  GenericRequestStatus? _savedStatus;
  GenericRequestStatus? get savedStatus => _savedStatus;
>>>>>>> 705d01ed6c6960a205e9f598933b4d4d4778fceb

  final TextEditingController eventName = TextEditingController();
  final TextEditingController eventValue = TextEditingController();
  final TextEditingController eventLocation = TextEditingController();
  final TextEditingController eventDescription = TextEditingController();

  EventType _eventType = EventType.UNKNOWN;
  EventType get eventType => _eventType;

  File? _eventImage;
  File? get eventImage => _eventImage;

  String? get existingImageUrl => _originalEvent?.eventImagePath;

  DateTime? _eventInitDate;
  DateTime? get eventInitDate => _eventInitDate;

  DateTime? _eventEndingDate;
  DateTime? get eventEndingDate => _eventEndingDate;

<<<<<<< HEAD
  bool get isFirstPhaseComplete {
    if (eventName.text.trim().isEmpty) return false;
    if (eventLocation.text.trim().isEmpty) return false;
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
=======
  void cleanController(){
    _originalEvent = null;
    _requestId = null;
    _savedStatus = null;
    _eventInitDate = null;
    _eventEndingDate = null;
    _eventImage = null;
>>>>>>> 705d01ed6c6960a205e9f598933b4d4d4778fceb
  }

  /// Carrega os dados do evento existente para edição e reenvio.
  void loadEventForEditing({
    required EventEntity event,
    required String requestId,
  }) {
    _originalEvent = event;
    _requestId = requestId;

    eventName.text = event.eventName;

    final totalValue = MaskFormatter.convertMoneyStringToDouble(event.eventValue,);
    final mandatoryProductsValue = event.products.fold<double>(0,(total, product) => total + (product.mandatory ? product.price : 0),);
    final baseValue = totalValue - mandatoryProductsValue;

    eventValue.text = MaskFormatter.convertMoneyDoubleToString( baseValue < 0 ? 0 : baseValue,);
    eventLocation.text = event.eventLocation;
    eventDescription.text = event.eventDescription ?? '';
    _eventType = event.eventType;
    _eventInitDate = event.eventInitDate;
    _eventEndingDate = event.eventEndingDate;

    _eventImage = null;
    notifyListeners();
  }

  void setEventLocation(String value) {
    eventLocation.text = value;
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

  EventEntity? buildEventEntity({
    required List<EventProductItem> products,
    required String userId,
    required String userNickname,
    required Set<String> selectedMemberIds,
    required ClassEntity? selectedClass,
  }) {
    double totalEventDoubleValue = MaskFormatter.convertMoneyStringToDouble(
      eventValue.text.trim(),
    );

    for (final product in products) {
      if (product.mandatory) {
        totalEventDoubleValue += product.price;
      }
    }

    final totalEventStringValue = MaskFormatter.convertMoneyDoubleToString(totalEventDoubleValue,);
    final now = DateTime.now();
    final originalEvent = _originalEvent;

    return EventEntity(
      eventId: originalEvent?.eventId ?? '',
      products: products,
      finishedEvent: originalEvent?.finishedEvent ?? false,
      eventType: eventType,
      eventCreatorId: originalEvent?.eventCreatorId ?? userId,
      eventName: eventName.text.trim(),
      eventCreatorNickname: originalEvent?.eventCreatorNickname ?? userNickname,
      eventValue: totalEventStringValue,
      eventInitDate: originalEvent?.eventInitDate ?? eventInitDate ?? now,
      selectedMembersId: selectedMemberIds,
      eventLocation: eventLocation.text.trim(),
      eventEndingDate: originalEvent?.eventEndingDate ?? eventEndingDate ?? now,
      selectedClassId: selectedClass?.classId ?? originalEvent?.selectedClassId,
      eventDescription: eventDescription.text.trim(),
      eventImagePath: originalEvent?.eventImagePath,
    );
  }

  void reset() {
    _originalEvent = null;
    _requestId = null;

    eventName.clear();
    eventValue.clear();
    eventLocation.clear();
    eventDescription.clear();

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
    eventName.dispose();
    eventValue.dispose();
    eventLocation.dispose();
    eventDescription.dispose();
    super.dispose();
  }
}
