import '../../domain/entities/fee_exemption_request_entity.dart';
import '../../domain/entities/fee_exemption_request_status_enum.dart';

class FeeExemptionRequestModel extends FeeExemptionRequestEntity {
  const FeeExemptionRequestModel({
    required super.idExemptionRequest,
    required super.professorId,
    required super.professorName,
    required super.status,
    required super.requestedAt,
    super.updatedAt,
    super.complementationReason,
    super.approvedAt,
    super.validUntil,
  });

  factory FeeExemptionRequestModel.fromMap(
    // Firebase -> Flutter
    String id,
    Map<String, dynamic> map,
  ) {
    return FeeExemptionRequestModel(
      idExemptionRequest: id,
      professorId: map['professorId'],
      professorName: map['professorName'],
      status: FeeExemptionStatus.values.byName(map['status'],),
      requestedAt: map['requestedAt'].toDate(),
      updatedAt: map['updatedAt']?.toDate(),
      complementationReason:map['complementationReason'],
      approvedAt: map['approvedAt']?.toDate(),
      validUntil: map['validUntil']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    // Flutter -> Firebase
    return {
      'professorId': professorId,
      'professorName': professorName,
      'status': status.name,
      'requestedAt': requestedAt,
      'updatedAt': updatedAt,
      'complementationReason': complementationReason,
      'approvedAt': approvedAt,
      'validUntil': validUntil,
    };
  }
}