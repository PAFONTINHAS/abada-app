import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_subscription_entity.dart';

class EventSubscriptionController extends ChangeNotifier{

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  
  List<EventSubscriptionEntity> _subscriptions = [];
  List<EventSubscriptionEntity> get subscriptions => _subscriptions;


  void setEventSubscriptions(List<EventSubscriptionEntity> subscriptions){
    _subscriptions = List<EventSubscriptionEntity>.from(subscriptions);

    notifyListeners();
  }

  void addEventSubscription(EventSubscriptionEntity subscription){

    final currentSubscriptionList = List<EventSubscriptionEntity>.from(_subscriptions);

    currentSubscriptionList.add(subscription);

    _subscriptions = currentSubscriptionList;

    notifyListeners();  
  }
}