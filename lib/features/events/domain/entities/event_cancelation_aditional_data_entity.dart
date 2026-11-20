class EventCancelationAditionalDataEntity {

  EventCancelationAditionalDataEntity({
    required this.reason,
    required this.details,
    required this.refundRequired,
  });

  final String reason;
  final String details;
  final bool refundRequired;

  Map<String, dynamic> toMap(){

    return {
      'reason': reason,
      'details': details,
      'refundRequired': refundRequired,
    };
  }
}