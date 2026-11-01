
import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';

import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/get_user_events_usecase.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/get_event_by_id_usecase.dart';

class CreatedEventsController extends ChangeNotifier {
  final GetUserEventsUsecase _getUserEventsUsecase;
  final GetEventByIdUsecase _getEventByIdUsecase;

  CreatedEventsController(
    this._getUserEventsUsecase,
    this._getEventByIdUsecase,
  );
  
  void cleanController(){
    _eventRequests.clear();
    _userEvents.clear();
  }

  List<EventRequestEntity> _eventRequests = [];
  List<EventRequestEntity> get eventRequests => _eventRequests;

  List<EventEntity> _userEvents = [];
  List<EventEntity> get userEvents => _userEvents;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> getUserEvents(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _getUserEventsUsecase.call(userId);

    final bool success = result.fold(
      (failure) {
        _errorMessage = failure.message;
        return false;
      },
      (userEvents) {
        _eventRequests = List.from(userEvents.eventRequests);
        _userEvents = List.from(userEvents.events);
        return true;
      },
    );

    _isLoading = false;
    notifyListeners();

    return success;
  }

  // RF22 - Busca o evento atualizado pelo ID para edição.
  Future<Either<Failure, EventEntity>> getEventById(
    String eventId,
  ) async {
    return _getEventByIdUsecase.call(eventId);
  }
}
