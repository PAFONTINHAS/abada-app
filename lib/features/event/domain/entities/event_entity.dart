class EventEntity {
  const EventEntity({
    required this.id,
    required this.title,
    required this.organizer,
    required this.dateTime,
    required this.location,
    required this.imagePath,
    required this.isPaid,
    required this.enrolledParticipants,
    this.creatorId = '',
    this.enrolledParticipantIds = const [],
    this.registrationsEnabled = true,
    this.cancellationRequested = false,
    this.refundTickets = const [],
  });

  final String id;
  final String title;
  final String organizer;
  final DateTime dateTime;
  final String location;
  final String imagePath;
  final bool isPaid;
  final int enrolledParticipants;
  final String creatorId;
  final List<String> enrolledParticipantIds;
  final bool registrationsEnabled;
  final bool cancellationRequested;
  final List<RefundTicketEntity> refundTickets;

  EventEntity copyWith({
    bool? cancellationRequested,
    bool? registrationsEnabled,
    List<RefundTicketEntity>? refundTickets,
  }) {
    final requestWasConfirmed =
        cancellationRequested == true && !this.cancellationRequested;
    return EventEntity(
      id: id,
      title: title,
      organizer: organizer,
      dateTime: dateTime,
      location: location,
      imagePath: imagePath,
      isPaid: isPaid,
      enrolledParticipants: enrolledParticipants,
      creatorId: creatorId,
      enrolledParticipantIds: enrolledParticipantIds,
      registrationsEnabled: registrationsEnabled ?? this.registrationsEnabled,
      cancellationRequested:
          cancellationRequested ?? this.cancellationRequested,
      refundTickets: requestWasConfirmed && isPaid
          ? List.generate(
              enrolledParticipants,
              (index) => RefundTicketEntity(
                id: '$id-refund-${index + 1}',
                participantNumber: index + 1,
                participantId: index < enrolledParticipantIds.length
                    ? enrolledParticipantIds[index]
                    : null,
              ),
            )
          : refundTickets ?? this.refundTickets,
    );
  }
}

class RefundTicketEntity {
  const RefundTicketEntity({
    required this.id,
    required this.participantNumber,
    this.participantId,
    this.paymentMethod,
    this.paymentDetails,
    this.status = RefundTicketStatus.pending,
  });

  final String id;
  final int participantNumber;
  final String? participantId;
  final String? paymentMethod;
  final String? paymentDetails;
  final RefundTicketStatus status;
  String get preferredPaymentMethod => 'PIX';
}

enum RefundTicketStatus { pending, paid }
