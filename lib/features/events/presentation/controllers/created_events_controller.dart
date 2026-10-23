import 'package:flutter/foundation.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/get_user_events_usecase.dart';

class CreatedEventsController extends ChangeNotifier{

  GetUserEventsUsecase _getUserEventsUsecase;

  CreatedEventsController(this._getUserEventsUsecase);

  List<EventRequestEntity> _eventRequests = [];
  List<EventRequestEntity> get eventRequests => _eventRequests;
  
  List<EventEntity> _userEvents = [];
  List<EventEntity> get userEvents => _userEvents;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> getUserEvents(String userId) async{

    _isLoading = true;
    notifyListeners();

    final result = await _getUserEventsUsecase.call(userId);

    final bool success = result.fold((failure){
      _errorMessage = failure.message;
      return false;
    }, (userEvents){

      _eventRequests = List.from(userEvents.eventRequests);
      _userEvents = List.from(userEvents.events);

      return true;
    });


    _isLoading = false;
    notifyListeners();

    return success;
  }

}