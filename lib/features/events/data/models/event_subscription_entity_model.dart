import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/core/utils/list_converter.dart';
import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/features/events/data/models/minor_student_subscription_entity_model.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/payment_method.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/subscription_status.dart';
import 'package:sistema_abada_capoeira/features/events/data/models/selcted_event_product_model.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_subscription_entity.dart';

class EventSubscriptionEntityModel extends EventSubscriptionEntity{

  const EventSubscriptionEntityModel({
    required super.userName,
    required super.id,
    required super.status,
    required super.userId,
    required super.eventId,
    required super.createdAt,
    required super.totalValue,
    required super.paymentMethod,
    required super.selectedProducts,
    required super.verificationCode,

    super.minorStudentSubscriptionData,

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
    final minorSubscriptionData = data['minorSubscriptionData'] != null
        ? MinorStudentSubscriptionEntityModel.fromSnapshot(data['minorSubscriptionData'])
        : null;

    return EventSubscriptionEntityModel(
      id: doc.id,
      status: status,
      userId: data['userId'],
      eventId: data['eventId'],
      paymentMethod: paymentMethod,
      totalValue: data['totalValue'],
      userName: data['userName'] ?? "",
      selectedProducts: selectedProducts,
      createdAt: createdAt ?? DateTime.now(),
      verificationCode: data['verificationCode'],
      minorStudentSubscriptionData: minorSubscriptionData
    );
  }
  factory EventSubscriptionEntityModel.fromEntity(EventSubscriptionEntity entity){

    return EventSubscriptionEntityModel(
      id: entity.id,
      status: entity.status,
      userId: entity.userId,
      eventId: entity.eventId,
      userName: entity.userName,
      createdAt: entity.createdAt,
      totalValue: entity.totalValue,
      paymentMethod: entity.paymentMethod,
      selectedProducts: entity.selectedProducts,
      verificationCode: entity.verificationCode,
      minorStudentSubscriptionData: entity.minorStudentSubscriptionData
    );
  }

  @override
  Map<String, dynamic> toMap() {

    LoggingService.displayInfo("Dados do menor: $minorStudentSubscriptionData");

    final map = {
      'userId': userId,
      'eventId': eventId,
      'userName': userName,
      'totalValue': totalValue,
      'status': status.name,
      'paymentMethod': paymentMethod.name,
      'verificationCode': verificationCode,
      'createdAt': createdAt,
      'selectedProducts': selectedProducts.map((product){
        return {
          'product': product.product,
          'price': product.price,
        };
      }),
    };

    if(minorStudentSubscriptionData != null){
      map.addAll({
        'minorStudentSubscriptionData': minorStudentSubscriptionData!.toMap()
      });
    }


    LoggingService.displayInfo("Mapa: $map");

    return map;
  }

}