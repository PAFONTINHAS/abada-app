class EventRequestDecisionParameters {
  final String requestId;
  final String eventId;
  final String coordinatorId;
  final String coordinatorName;
  final String reason;

  const EventRequestDecisionParameters({
    required this.requestId,
    required this.eventId,
    required this.coordinatorId,
    required this.coordinatorName,
    required this.reason,
  });
}
