import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_decision_parameters.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/get_pending_events_requests_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/reject_event_request_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/request_event_changes_usecase.dart';
class EventRequestsController extends ChangeNotifier {
  final GetPendingEventsRequestsUsecase _getPendingUsecase;
  final RejectEventRequestUsecase _rejectUsecase;
  final RequestEventChangesUsecase _changesUsecase;

  EventRequestsController(
    this._getPendingUsecase,
    this._rejectUsecase,
    this._changesUsecase,
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
      final result = await _getPendingUsecase.call();

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

  Future<bool> reject(EventRequestDecisionParameters params) {
    return _execute(() => _rejectUsecase.call(params), params.requestId);
  }

  Future<bool> requestChanges(EventRequestDecisionParameters params) {
    return _execute(() => _changesUsecase.call(params), params.requestId);
  }

  Future<bool> _execute(Future<Either<Failure, void>> Function() action,String requestId,
  //Centraliza o fluxo de decisão: liga _isProcessing, executa o UseCase injetado, 
  //trata o Either, atualiza erros e a lista, e notifica a interface
  ) async {
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
          _eventRequests.removeWhere(
            (request) => request.requestId == requestId,
          );
          return true;
        },
      );
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
}
