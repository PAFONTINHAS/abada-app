
import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/utils/generator.dart';
import 'package:sistema_abada_capoeira/core/utils/mask_formatter.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/models/payment_method.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_products_item.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/selected_event_products.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_subscription_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/usecases/subscribe_to_event_usecase.dart';

class EventSubscriptionController extends ChangeNotifier{

  final SubscribeToEventUsecase _subscribeToEventUsecase;

  EventSubscriptionController(this._subscribeToEventUsecase);

  PaymentMethod _paymentMethod = PaymentMethod.pix;
  PaymentMethod get paymentMethod => _paymentMethod;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  EventEntity? _currentEvent;
  EventEntity? get currentEvent => _currentEvent; 

  void setPaymentMethod(PaymentMethod method){
    _paymentMethod = method;
    notifyListeners();
  }

  Set<EventProductItem> _selectedOptionalProducts = {};
  Set<EventProductItem> get selectedOptionalProducts => _selectedOptionalProducts;

  double get totalAmount{

    if(_currentEvent == null) return 0.0;

    double total = MaskFormatter.convertMoneyStringToDouble(_currentEvent!.eventValue);

    for (final product in _currentEvent!.products) {
      if (!product.mandatory && _selectedOptionalProducts.contains(product)){
        total += product.price;
      }
    }

    return total;

  }

  void setEvent(EventEntity event){

    _currentEvent = event;
    notifyListeners();
  }

  void addOptionalProduct(EventProductItem product){
    final currentProducts = Set<EventProductItem>.from(_selectedOptionalProducts);

    currentProducts.add(product);

    _selectedOptionalProducts = currentProducts;

    notifyListeners();

  }

  void removeOptionalProduct(EventProductItem product){

    final currentProducts = Set<EventProductItem>.from(_selectedOptionalProducts);

    currentProducts.remove(product);

    _selectedOptionalProducts = currentProducts;

    notifyListeners();
  }

  

  
  Future<bool> processPayment(String userId) async {

    _isProcessing = true;
    notifyListeners();

    if(_currentEvent == null) return false;

    String eventReceipt = Generator.generateVerificationCode(userId, _currentEvent!.eventId);


    final double totalAmount = this.totalAmount;

    final Set<SelectedEventProduct> selectedEventProducts =
      _selectedOptionalProducts.map(
        (product) => SelectedEventProduct(
          product: product.product,
          price: product.price,
        ),
      )
      .toSet();

    final subscription = EventSubscriptionEntity(
      id: '',
      userId: userId,
      totalValue: totalAmount,
      verificationCode: eventReceipt,
      eventId: _currentEvent!.eventId,
      paymentMethod: _paymentMethod.name,
      status: SubscriptionStatus.subscribed,
      selectedProducts: selectedEventProducts,
      createdAt: DateTime.now(),
    );
   

    final success = await subscribeToEvent(subscription);
   
    _isProcessing = false;
    notifyListeners();

    return success;
  }

  Future<bool> subscribeToEvent(EventSubscriptionEntity entity) async{

    final result = await _subscribeToEventUsecase.call(entity);

    return result.fold((failiure)=> false, (_) => true); 
  }
  

  

}