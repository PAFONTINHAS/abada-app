import 'package:sistema_abada_capoeira/features/events/domain/entities/payment_method.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/subscription_status.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/selected_event_product.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/minor_subscription_data.dart';


class EventSubscriptionEntity {
  final String id;
  final String eventId;
  final String userId;
  final String userName;
  final double totalValue;
  final DateTime createdAt;
  final String verificationCode;
  final SubscriptionStatus status;
  final PaymentMethod paymentMethod;
  final Set<SelectedEventProduct> selectedProducts;
  final MinorStudentSubscriptionData? minorStudentSubscriptionData;


  const EventSubscriptionEntity({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.userName,
    required this.createdAt,
    required this.totalValue,
    required this.paymentMethod,
    required this.selectedProducts,
    required this.verificationCode,

    this.minorStudentSubscriptionData,
    this.status = SubscriptionStatus.subscribed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'eventId': eventId,
      'status': status.name,
      'totalValue': totalValue,
      'paymentMethod': paymentMethod,
      'selectedProducts': selectedProducts,
      'verificationCode': verificationCode,
      'createdAt': createdAt,
    };
  }

  EventSubscriptionEntity copyWith({
    String? id,
    String? userId,
    String? eventId,
    String? classId,
    String? userName,
    double? totalValue,
    DateTime? createdAt,
    String? legalGuardian,
    String? verificationCode,
    SubscriptionStatus? status,
    PaymentMethod? paymentMethod,
    String? legalGuardianPhoneNumber,
    Set<SelectedEventProduct>? selectedProducts,
    MinorStudentSubscriptionData? minorStudentSubscriptionData,
    
  }){

    return EventSubscriptionEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      eventId: eventId ?? this.eventId,
      totalValue: totalValue ?? this.totalValue,
      selectedProducts: Set<SelectedEventProduct>.from(
        selectedProducts ?? this.selectedProducts,
      ),
      status: status ?? this.status,
      userName: userName ?? this.userName,
      createdAt: createdAt ?? this.createdAt,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      verificationCode: verificationCode ?? this.verificationCode,
      minorStudentSubscriptionData: minorStudentSubscriptionData ?? this.minorStudentSubscriptionData
    );
  }
}