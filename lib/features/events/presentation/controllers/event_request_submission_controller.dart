
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/create_event_request_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/resubmit_event_request_usecase.dart';

class EventRequestSubmissionController extends ChangeNotifier {
  final CreateEventRequestUsecase _createEventRequestUsecase;
  final ResubmitEventRequestUsecase _resubmitEventRequestUsecase;

  EventRequestSubmissionController(
    this._createEventRequestUsecase,
    this._resubmitEventRequestUsecase,
  );

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  GenericRequestStatus? _savedStatus;
  GenericRequestStatus? get savedStatus => _savedStatus;

  Future<bool> createEventRequest(
    EventEntity event,
    File? eventImage,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _createEventRequestUsecase.call(
        event,
        eventImage,
      );

      return result.fold(
        (failure) {
          _errorMessage = failure.message;
          return false;
        },
        (_) => true,
      );
    } catch (exception) {
      _errorMessage = 'Não foi possível criar a solicitação.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resubmitEventRequest({
    required String? requestId,
    required EventEntity event,
    required File? eventImage,
  }) async {
    if (requestId == null ||
        requestId.trim().isEmpty ||
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
        requestId,
        event,
        eventImage,
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
    _isLoading = false;
    _errorMessage = null;
    _savedStatus = null;
    notifyListeners();
  }
}
