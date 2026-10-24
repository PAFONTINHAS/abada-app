import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/get_events_usecase.dart';

class EventsController extends ChangeNotifier{

  final GetEventsUsecase _getEventsUsecase;

  EventsController(this._getEventsUsecase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<EventEntity> _events = [];
  List<EventEntity> get events => _events;

  TextEditingController eventSearchController = TextEditingController();

  Future<bool> getEvents() async{

    _isLoading = true;
    notifyListeners();

    final result = await _getEventsUsecase.call();

    final bool success = result.fold((failure){
      _errorMessage = failure.message;
      return false;
    }, (fetchedEvents){

      _events = List.from(fetchedEvents);

      return true;
    });

    _isLoading = false;
    notifyListeners();

    return success;
  }

}