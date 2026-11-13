enum EventCancellationStatus { pending, approved, rejected }

class EventCancellationRequestEntity {
  const EventCancellationRequestEntity({
    required this.id,
    required this.eventId,
    this.eventTitle = '',
    required this.requesterId,
    required this.creatorId,
    required this.reason,
    required this.details,
    required this.requestedAt,
    this.status = EventCancellationStatus.pending,
    this.reviewedAt,
    this.reviewerId,
    this.refundRequired = false,
    this.refundTicketIds = const [],
  });

  final String id;
  final String eventId;
  final String eventTitle;
  final String requesterId;
  final String creatorId;
  final String reason;
  final String details;
  final DateTime requestedAt;
  final EventCancellationStatus status;
  final DateTime? reviewedAt;
  final String? reviewerId;
  final bool refundRequired;
  final List<String> refundTicketIds;

  EventCancellationRequestEntity copyWith({
    EventCancellationStatus? status,
    DateTime? reviewedAt,
    String? reviewerId,
    List<String>? refundTicketIds,
  }) {
    return EventCancellationRequestEntity(
      id: id,
      eventId: eventId,
      eventTitle: eventTitle,
      requesterId: requesterId,
      creatorId: creatorId,
      reason: reason,
      details: details,
      requestedAt: requestedAt,
      status: status ?? this.status,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewerId: reviewerId ?? this.reviewerId,
      refundRequired: refundRequired,
      refundTicketIds: refundTicketIds ?? this.refundTicketIds,
    );
  }
}
