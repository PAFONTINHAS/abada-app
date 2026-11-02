import 'package:sistema_abada_capoeira/features/events/domain/entities/event_subscription_entity.dart';

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