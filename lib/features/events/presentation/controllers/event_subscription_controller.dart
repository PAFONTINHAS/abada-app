import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_subscription_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/get_event_subscriptions_usecase.dart';

class EventSubscriptionController extends ChangeNotifier{

  final GetEventSubscriptionsUsecase _getEventSubscriptionsUsecase;

  EventSubscriptionController(this._getEventSubscriptionsUsecase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  
  List<EventSubscriptionEntity> _subscriptions = [];
  List<EventSubscriptionEntity> get subscriptions => _subscriptions;

  Future<bool> getEventSubscriptions(String userId) async{

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _getEventSubscriptionsUsecase.call(userId);

    final success = result.fold((failure){
      _errorMessage = failure.message;
      return false;
    }, (fetchedSubscriptions){

      _subscriptions = List<EventSubscriptionEntity>.from(fetchedSubscriptions);

      return true;
    });

    _isLoading = false;

    notifyListeners();

    return success;
  }
}