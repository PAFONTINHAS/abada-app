import 'package:sistema_abada_capoeira/features/events/domain/entities/selected_event_product.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/subscription_status.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/payment_method.dart';


class EventSubscriptionEntity {
  final String id;
  final String eventId;
  final String userId;
  final String? classId;
  final double totalValue;
  final DateTime createdAt;
  final PaymentMethod paymentMethod;
  final String verificationCode;
  final SubscriptionStatus status;
  final Set<SelectedEventProduct> selectedProducts;

  const EventSubscriptionEntity({
    this.classId,
    required this.id,
    required this.userId,
    required this.eventId,
    required this.createdAt,
    required this.totalValue,
    required this.paymentMethod,
    required this.selectedProducts,
    required this.verificationCode,
    this.status = SubscriptionStatus.subscribed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventId': eventId,
      'userId': userId,
      'classId': classId,
      'totalValue': totalValue,
      'selectedProducts': selectedProducts,
      'paymentMethod': paymentMethod,
      'verificationCode': verificationCode,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  EventSubscriptionEntity copyWith({
    String? id,
    String? eventId,
    String? userId,
    String? classId,
    double? totalValue,
    DateTime? createdAt,
    String? verificationCode,
    SubscriptionStatus? status,
    PaymentMethod? paymentMethod,
    Set<SelectedEventProduct>? selectedProducts,
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
      classId: classId ?? this.classId,
      createdAt: createdAt ?? this.createdAt,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      verificationCode: verificationCode ?? this.verificationCode,
    );
  }
}