import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/utils/mask_formatter.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/models/payment_method.dart';

class EventSubscriptionController extends ChangeNotifier{

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

  Set<String> _selectedOptionalProducts = {};
  Set<String> get selectedOptionalProducts => _selectedOptionalProducts;

  double get totalAmount{

    if(_currentEvent == null) return 0.0;

    double total = MaskFormatter.convertMoneyStringToDouble(_currentEvent!.eventValue);

    for (final product in _currentEvent!.products) {
      if (!product.mandatory && _selectedOptionalProducts.contains(product.product)) {
        total += product.price;
      }
    }

    return total;

  }

  void setEvent(EventEntity event){

    _currentEvent = event;
    notifyListeners();
  }

  
  Future<bool> processPayment() async {

    _isProcessing = true;
    notifyListeners();

    // Simula a requisição da gateway / webhook
    await Future.delayed(const Duration(seconds: 2));

    // TODO: Enviar no seu controller `_selectedOptionalProducts.toList()` e o `_totalAmount`
    // await context.read<EventDetailsController>().subscribeUserToEvent(
    //   eventId: widget.event.id,
    //   selectedProducts: _selectedOptionalProducts.toList(),
    //   totalValue: _totalAmount,
    // );

    _isProcessing = false;
    notifyListeners();

    return true;

    // Navigator.of(context).pop();

    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('Inscrição e produtos confirmados com sucesso!'),
    //     backgroundColor: Colors.green,
    //   ),
    // );
  }
  

  

}