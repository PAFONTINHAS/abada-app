import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_subscription_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/get_event_subscriptions_usecase.dart';

class GeneralEventSubscriptionsController extends ChangeNotifier{

  final GetEventSubscriptionsUsecase _getEventSubscriptionsUsecase;

  GeneralEventSubscriptionsController(this._getEventSubscriptionsUsecase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<EventSubscriptionEntity> _eventSubscriptions = [];
  List<EventSubscriptionEntity> get eventSubscriptions => _eventSubscriptions;


  Future<bool> getEventSubscriptions(String eventId) async{

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    LoggingService.displayInfo("Pegando inscrições do evento");

    final result = await _getEventSubscriptionsUsecase.call(eventId);

    final success = result.fold((failure){
      _errorMessage = failure.message;
      return false;
    }, (subscriptions){

      _eventSubscriptions = List<EventSubscriptionEntity>.from(subscriptions);

      return true;
    });

    _isLoading = false;
    notifyListeners();

    return success;
  }


} 