import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_products_item.dart';

class EventProductsController extends ChangeNotifier{

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  bool _mandatoryProduct = false;
  bool get optionalProduct => _mandatoryProduct;

  List<EventProductItem> _products = [];
  List<EventProductItem> get products => _products;  

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void setOptionalProduct(bool value){
    _mandatoryProduct = value;

    notifyListeners();
  }


  void addProduct(){
    if(nameController.text.trim().isEmpty) return;
    
    final currentProductsList = List.from(_products);

    final cleanPrice = priceController.text
      .replaceAll('R\$', '')
      .replaceAll('.', '')
      .replaceAll(',', '.')
      .trim();

    final double price = double.tryParse(cleanPrice) ?? 0.0;

    currentProductsList.add(EventProductItem(product: nameController.text.trim(), price: price, mandatory: _mandatoryProduct));

    _products = List.from(currentProductsList);

    nameController.clear();
    priceController.clear();
    _mandatoryProduct = false;

    notifyListeners();
  }

  void removeProduct(int index) {

    final currentProductsList = List.from(_products);

    currentProductsList.removeAt(index);

    _products = List.from(currentProductsList);
    notifyListeners();
  }


}