import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';

class GenericRequestUpdateParameters {
  final String requestId;
  final String rejectionReason;
  final String changeReason;
  final DateTime? updatedAt;
  final GenericRequestStatus status;

  const GenericRequestUpdateParameters({
    this.updatedAt,
    this.changeReason = '',
    required this.requestId,
    this.rejectionReason = '',
    this.status = GenericRequestStatus.requested,
  });
}