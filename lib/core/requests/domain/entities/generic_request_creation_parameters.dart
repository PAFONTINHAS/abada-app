
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';

class GenericRequestCreationParameters {
  final String requestId;
  final String rejectionReason;
  final String changeReason;
  final DateTime requestedAt;
  final DateTime? updatedAt;
  final GenericRequestStatus status;

  const GenericRequestCreationParameters({
    required this.requestId,
    required this.requestedAt, 
    this.rejectionReason = '',
    this.changeReason = '',
    this.updatedAt,
    this.status = GenericRequestStatus.requested,
  });


}