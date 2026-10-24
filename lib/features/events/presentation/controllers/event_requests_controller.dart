import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/get_pending_events_requests_usecase.dart';

class EventRequestsController extends ChangeNotifier{

  final GetPendingEventsRequestsUsecase _getPendingEventsRequestsUsecase;

  EventRequestsController(this._getPendingEventsRequestsUsecase);

  TextEditingController reasonController = TextEditingController();

  List<EventRequestEntity> _eventRequests = [];
  List<EventRequestEntity> get eventRequests => _eventRequests;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> getPendingRequests() async{
    
    _isLoading = true;
    notifyListeners();

    final result = await _getPendingEventsRequestsUsecase.call();

    final bool success = result.fold((failure){
      _errorMessage = failure.message;
      return false;
    }, (requests){
      _eventRequests = requests;

      return true;
    });


    _isLoading = false;
    notifyListeners();

    return success;
  }
}