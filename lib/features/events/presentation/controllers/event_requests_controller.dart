import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_decision_parameters.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/approve_event_cancelation_request_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/approve_event_creation_request_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/get_pending_events_requests_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/reject_event_request_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/request_event_changes_usecase.dart';
class EventRequestsController extends ChangeNotifier {
  final RejectEventRequestUsecase _rejectEventRequestUsecase;
  final RequestEventChangesUsecase _requestEventChangesUsecase;
  final GetPendingEventsRequestsUsecase _getPendingEventsRequestsUsecase;
  final ApproveEventCreationRequestUsecase _approveEventCreationRequestUsecase;
  final ApproveEventCancelationRequestUsecase _approveEventCancelationRequestUsecase;


  EventRequestsController(
    this._rejectEventRequestUsecase,
    this._requestEventChangesUsecase,
    this._getPendingEventsRequestsUsecase,
    this._approveEventCreationRequestUsecase,
    this._approveEventCancelationRequestUsecase,
  );

  List<EventRequestEntity> _eventRequests = [];
  List<EventRequestEntity> get eventRequests => _eventRequests;

  bool _isLoading = false; //carrega a tela
  bool get isLoading => _isLoading;

  bool _isProcessing = false; //evita duas ações ao mesmo tempo
  bool get isProcessing => _isProcessing;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _actionError;
  String? get actionError => _actionError;

  void cleanController(){
    _eventRequests.clear();
  }

  Future<bool> getPendingRequests() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _getPendingEventsRequestsUsecase.call();

      return result.fold((failure) {
          _errorMessage = failure.message;
          return false;
        },
        (requests) {
          _eventRequests = requests;
          return true;
        },
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<bool> approveCreationRequest(EventRequestEntity request){
    return _execute(() => _approveEventCreationRequestUsecase.call(request), request.requestId);
  }

  Future<bool> approveCancelationRequest(EventRequestEntity request){
    return _execute(() => _approveEventCancelationRequestUsecase.call(request), request.requestId);
  }

  Future<bool> reject(EventRequestDecisionParameters params) {
    return _execute(() => _rejectEventRequestUsecase.call(params), params.requestId);
  }

  Future<bool> requestChanges(EventRequestDecisionParameters params) {
    return _execute(() => _requestEventChangesUsecase.call(params), params.requestId);
  }

  Future<bool> _execute(Future<Either<Failure, void>> Function() action, String requestId) async {
    if (_isProcessing) return false;
    _isProcessing = true;
    _actionError = null;
    notifyListeners();

    try {
      final result = await action();
      return result.fold(
        (failure) {
          _actionError = failure.message;
          return false;
        },
        (_) {

          final requests = List<EventRequestEntity>.from(_eventRequests);
          requests.removeWhere((request) => request.requestId == requestId);

          _eventRequests = requests;
          return true;
        },
      );
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
}
