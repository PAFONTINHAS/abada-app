import 'package:sistema_abada_capoeira/features/events/domain/entities/selected_event_product.dart';

class SelectedEventProductModel extends SelectedEventProduct{

  SelectedEventProductModel({
    required super.product,
    required super.price,
  });

  factory SelectedEventProductModel.fromMap(Map<String, dynamic> data) {
    return SelectedEventProductModel(
      product: data['product'],
      price: data['price'],
    );
  }

}