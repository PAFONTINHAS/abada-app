import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/utils/mask_formatter.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_products_item.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/create_event_request_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/resubmit_event_request_usecase.dart';

class EventFormController extends ChangeNotifier {
  final CreateEventRequestUsecase _createEventRequestUsecase;
  final ResubmitEventRequestUsecase _resubmitEventRequestUsecase;

  EventFormController(
    this._createEventRequestUsecase,
    this._resubmitEventRequestUsecase,
  );

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  EventEntity? _originalEvent;
  bool get isEditing => _originalEvent != null;
  
  String? _requestId;
  String? get requestId => _requestId;

  GenericRequestStatus? _savedStatus;
  GenericRequestStatus? get savedStatus => _savedStatus;

  final TextEditingController eventName = TextEditingController();
  final TextEditingController eventValue = TextEditingController();
  final TextEditingController eventLocation = TextEditingController();
  final TextEditingController eventDescription = TextEditingController();

  bool get isFirstPhaseComplete {
    if (eventName.text.trim().isEmpty) return false;
    if (eventLocation.text.trim().isEmpty) return false;

    return true;
  }

  bool get isSecondPhaseComplete {
    return _eventType != EventType.UNKNOWN;
  }

  EventType _eventType = EventType.UNKNOWN;
  EventType get eventType => _eventType;

  File? _eventImage;
  File? get eventImage => _eventImage;

  String? get existingImageUrl => _originalEvent?.eventImagePath;

  DateTime? _eventInitDate;
  DateTime? get eventInitDate => _eventInitDate;

  DateTime? _eventEndingDate;
  DateTime? get eventEndingDate => _eventEndingDate;

  void cleanController(){
    _originalEvent = null;
    _requestId = null;
    _savedStatus = null;
    _eventInitDate = null;
    _eventEndingDate = null;
    _eventImage = null;
  }

  /// Carrega os dados do evento existente para edição e reenvio.
  void loadEventForEditing({
    required EventEntity event,
    required String requestId,
  }) {
    _originalEvent = event;
    _requestId = requestId;

    eventName.text = event.eventName;
    final totalValue = MaskFormatter.convertMoneyStringToDouble(
      event.eventValue,
    );

    final mandatoryProductsValue = event.products.fold<double>(
      0,
      (total, product) => total + (product.mandatory ? product.price : 0),
    );

    final baseValue = totalValue - mandatoryProductsValue;

    eventValue.text = MaskFormatter.convertMoneyDoubleToString(
      baseValue < 0 ? 0 : baseValue,
    );
    eventLocation.text = event.eventLocation;
    eventDescription.text = event.eventDescription ?? '';

    _eventType = event.eventType;
    _eventInitDate = event.eventInitDate;
    _eventEndingDate = event.eventEndingDate;

    _eventImage = null;
    _errorMessage = null;

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

    final totalEventStringValue = MaskFormatter.convertMoneyDoubleToString(
      totalEventDoubleValue,
    );

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

  // Cria um novo evento e sua solicitação.
  Future<bool> createEventRequest(EventEntity event) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _createEventRequestUsecase.call(event, _eventImage);

      return result.fold((failure) {
        _errorMessage = failure.message;
        return false;
      }, (_) => true);
    } catch (exception) {
      _errorMessage = 'Não foi possível criar a solicitação.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reenvia um evento corrigido sem criar outra solicitação.
  Future<bool> resubmitEventRequest(EventEntity event) async {
    final currentRequestId = _requestId;

    if (currentRequestId == null ||
        currentRequestId.trim().isEmpty ||
        event.eventId.trim().isEmpty) {
      _errorMessage = 'Solicitação ou evento inválido.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _resubmitEventRequestUsecase.call(
        currentRequestId,
        event,
        _eventImage,
      );

      return result.fold(
        (failure) {
          _errorMessage = failure.message;
          return false;
        },
        (status) {
          _savedStatus = status;
          return true;
        },
      );
    } catch (exception) {
      _errorMessage = 'Não foi possível reenviar o evento.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _originalEvent = null;
    _requestId = null;
    _savedStatus = null;

    eventName.clear();
    eventValue.clear();
    eventLocation.clear();
    eventDescription.clear();

    _eventType = EventType.UNKNOWN;
    _eventImage = null;
    _eventInitDate = null;
    _eventEndingDate = null;

    _errorMessage = null;
    _isLoading = false;

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
