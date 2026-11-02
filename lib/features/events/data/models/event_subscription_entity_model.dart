import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/core/utils/list_converter.dart';
import 'package:sistema_abada_capoeira/features/events/data/models/selcted_event_product_model.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_subscription_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/payment_method.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/subscription_status.dart';

class EventSubscriptionEntityModel extends EventSubscriptionEntity{

  const EventSubscriptionEntityModel({
    super.classId,
    required super.id,
    required super.status,
    required super.userId,
    required super.eventId,
    required super.createdAt,
    required super.totalValue,
    required super.paymentMethod,
    required super.selectedProducts,
    required super.verificationCode,
  });
  

  factory EventSubscriptionEntityModel.fromSnapshot(DocumentSnapshot doc){
    final data = doc.data() as Map<String, dynamic>;

    final selectedProducts = ListConverter.fromDynamicList(
      data['selectedProducts'],
      (map) => SelectedEventProductModel.fromMap(map),
    ).toSet();

    final createdAt = DateController.toDate(data['createdAt']);
    final status = SubscriptionStatusExtension.fromString(data['status']);
    final paymentMethod = PaymentMethodExtension.fromString(data['paymentMethod']);

    return EventSubscriptionEntityModel(
      id: doc.id,
      status: status,
      userId: data['userId'],
      eventId: data['eventId'],
      createdAt: createdAt ?? DateTime.now(),
      totalValue: data['totalValue'],
      paymentMethod: paymentMethod,
      selectedProducts: selectedProducts,
      verificationCode: data['verificationCode'],
    );
  }
  factory EventSubscriptionEntityModel.fromEntity(EventSubscriptionEntity entity){

    return EventSubscriptionEntityModel(
      id: entity.id,
      status: entity.status,
      userId: entity.userId,
      eventId: entity.eventId,
      classId: entity.classId,
      createdAt: entity.createdAt,
      totalValue: entity.totalValue,
      paymentMethod: entity.paymentMethod,
      selectedProducts: entity.selectedProducts,
      verificationCode: entity.verificationCode,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'eventId': eventId,
      'classId': classId,
      'totalValue': totalValue,
      'selectedProducts': selectedProducts.map((product){
        return {
          'product': product.product,
          'price': product.price,
        };
      }),
      'paymentMethod': paymentMethod,
      'verificationCode': verificationCode,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

}