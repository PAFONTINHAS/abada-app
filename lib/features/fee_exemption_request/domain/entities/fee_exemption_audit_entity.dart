class FeeExemptionAuditEntity {
  final String id;
  final String requestId;

  final String action;
  final String performedBy;

  final DateTime performedAt;
  final String justification;

  const FeeExemptionAuditEntity({
    required this.id,
    required this.requestId,
    required this.action,
    required this.performedBy,
    required this.performedAt,
    required this.justification,
  });
}