import 'package:sistema_abada_capoeira/features/events/domain/entities/event_products_item.dart';

class EventProductItemModel extends EventProductItem{

  EventProductItemModel({
    required super.product,
    required super.price,
    required super.mandatory
  });


  factory EventProductItemModel.fromSnapshot(Map<String, dynamic> snapshot){

    return EventProductItemModel(
      product: snapshot['product'],
      price: snapshot['price'],
      mandatory: snapshot['mandatory'],
    );
  }

}