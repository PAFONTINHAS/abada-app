import 'package:flutter/foundation.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/get_event_by_id_usecase.dart';

class EventDetailsController extends ChangeNotifier{

  final GetEventByIdUsecase _getEventByIdUsecase;

  EventDetailsController(this._getEventByIdUsecase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  EventEntity? _eventEntity;
  EventEntity? get eventEntity => _eventEntity;

  Future<bool> getEventById(String eventId) async{

    LoggingService.displayInfo("Pegando evento pelo id: $eventId");

    _isLoading = false;
    notifyListeners();

    final result = await _getEventByIdUsecase.call(eventId);

    final success = result.fold((failure){
      _errorMessage = failure.message;
      return false;
    }, (event){

      LoggingService.displayInfo("Evento capturado: $event");


      _eventEntity = event;
      return true;
    });

    _isLoading = false;
    notifyListeners();

    return success;
  }

  void setEventEntity(EventEntity event){

    _eventEntity = event;
    notifyListeners();
  }
}