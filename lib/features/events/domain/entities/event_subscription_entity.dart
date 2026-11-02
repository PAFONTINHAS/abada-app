import 'package:sistema_abada_capoeira/features/events/domain/entities/event_products_item.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/selected_event_products.dart';

enum SubscriptionStatus { subscribed, confirmed, canceled }

class EventSubscriptionEntity {
  final String id;
  final String eventId;
  final String userId;
  final String? classId;
  final double totalValue;
  final DateTime createdAt;
  final String paymentMethod;
  final String verificationCode;
  final SubscriptionStatus status;
  final Set<SelectedEventProduct> selectedProducts;

  const EventSubscriptionEntity({
    required this.id,
    required this.eventId,
    required this.userId,
    this.classId,
    required this.totalValue,
    required this.selectedProducts,
    required this.paymentMethod,
    required this.verificationCode,
    required this.status,
    required this.createdAt,
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
    String? paymentMethod,
    String? verificationCode,
    SubscriptionStatus? status,
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