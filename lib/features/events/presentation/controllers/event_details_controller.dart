import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_policy.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/get_event_by_id_usecase.dart';

class EventDetailsController extends ChangeNotifier {
  final GetEventByIdUsecase _getEventByIdUsecase;
  final FirebaseFirestore? _firestore;
  EventDetailsController(
    this._getEventByIdUsecase, {
    FirebaseFirestore? firestore,
  }) : _firestore = firestore;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  EventEntity? _eventEntity;
  EventEntity? get eventEntity => _eventEntity;
  String? _verifiedRequestId;
  int _generation = 0;

  bool canDecide(String requestId, String eventId) =>
      !_isLoading &&
      _errorMessage == null &&
      _verifiedRequestId == requestId &&
      _eventEntity?.eventId == eventId;

  Future<bool> getEventById(String eventId, {String? requestId}) async {
    final generation = ++_generation;
    _isLoading = true;
    _errorMessage = null;
    _eventEntity = null;
    _verifiedRequestId = null;
    notifyListeners();
    try {
      final result = await _getEventByIdUsecase.call(eventId);
      EventEntity? loaded;
      String? error;
      result.fold(
        (failure) => error = failure.message,
        (event) => loaded = event,
      );
      if (error != null) throw StateError(error!);
      if (loaded?.eventId != eventId) throw StateError('Evento incorreto.');
      if (requestId != null) {
        final request = await (_firestore ?? FirebaseFirestore.instance)
            .collection('event_requests')
            .doc(requestId)
            .get();
        final data = request.data();
        final status = GenericRequestStatusExtension.fromString(
          data?['status'] as String? ?? '',
        );
        if (data?['eventId'] != eventId ||
            data?['requesterId'] != loaded!.eventCreatorId ||
            !EventRequestPolicy.canDecide(status)) {
          throw StateError('Evento e solicitação não podem ser analisados.');
        }
      }
      if (generation != _generation) return false;
      _eventEntity = loaded;
      _verifiedRequestId = requestId;
      return true;
    } catch (error) {
      if (generation == _generation) _errorMessage = error.toString();
      return false;
    } finally {
      if (generation == _generation) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void setEventEntity(EventEntity event) {
    ++_generation;
    _isLoading = false;
    _errorMessage = null;
    _verifiedRequestId = null;
    _eventEntity = event;
    notifyListeners();
  }
}
