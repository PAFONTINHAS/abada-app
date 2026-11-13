import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/domain/entities/event_cancellation_request_entity.dart';

class EventCancellationRequestModel extends EventCancellationRequestEntity {
  const EventCancellationRequestModel({
    required super.id,
    required super.eventId,
    super.eventTitle,
    required super.requesterId,
    required super.creatorId,
    required super.reason,
    required super.details,
    required super.requestedAt,
    super.status,
    super.reviewedAt,
    super.reviewerId,
    super.refundRequired,
    super.refundTicketIds,
  });

  factory EventCancellationRequestModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? {};
    return EventCancellationRequestModel(
      id: snapshot.id,
      eventId: data['eventId'] as String? ?? '',
      eventTitle: data['eventTitle'] as String? ?? '',
      requesterId: data['requesterId'] as String? ?? '',
      creatorId: data['creatorId'] as String? ?? '',
      reason: data['reason'] as String? ?? '',
      details: data['details'] as String? ?? '',
      requestedAt:
          (data['requestedAt'] as Timestamp?)?.toDate() ??
          DateTime.fromMillisecondsSinceEpoch(0),
      status: EventCancellationStatus.values.firstWhere(
        (value) => value.name == data['status'],
        orElse: () => EventCancellationStatus.pending,
      ),
      reviewedAt: (data['reviewedAt'] as Timestamp?)?.toDate(),
      reviewerId: data['reviewerId'] as String?,
      refundRequired: data['refundRequired'] as bool? ?? false,
      refundTicketIds: List<String>.from(
        data['refundTicketIds'] as List? ?? [],
      ),
    );
  }

  Map<String, dynamic> toMap() => {
    'eventId': eventId,
    'eventTitle': eventTitle,
    'requesterId': requesterId,
    'creatorId': creatorId,
    'reason': reason,
    'details': details,
    'requestedAt': Timestamp.fromDate(requestedAt),
    'status': status.name,
    'reviewedAt': reviewedAt == null ? null : Timestamp.fromDate(reviewedAt!),
    'reviewerId': reviewerId,
    'refundRequired': refundRequired,
    'refundTicketIds': refundTicketIds,
  };
}
