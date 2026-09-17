import 'package:sistema_abada_capoeira/features/fee_exemption_request/domain/entities/fee_exemption_request_status_enum.dart';

class FeeExemptionRequestEntity {
  final String idExemptionRequest;
  final String professorId;
  final String professorName;
  final FeeExemptionStatus status;
  final DateTime requestedAt;
  final DateTime? updatedAt;
  final String? complementationReason;
  final DateTime? approvedAt;
  final DateTime? validUntil;

  const FeeExemptionRequestEntity({
    required this.idExemptionRequest,
    required this.professorId,
    required this.professorName,
    required this.status,
    required this.requestedAt,
    this.updatedAt,
    this.complementationReason,
    this.approvedAt,
    this.validUntil,
  });
}
