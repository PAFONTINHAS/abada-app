import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';

class GenericRequestUpdateParameters {
  final String requestId;
  final String rejectionReason;
  final String changeReason;
  final DateTime? updatedAt;
  final GenericRequestStatus status;
  final Map<String, dynamic> additionalData; //map = chave - valor, guarda valors
  //envia informações extras mudam de uma solicitação para outra,só armazena os dados
  final Map<GenericRequestStatus, GenericRequestStatus>? transitions;

  const GenericRequestUpdateParameters({
    this.updatedAt,
    this.changeReason = '',
    required this.requestId,
    this.rejectionReason = '',
    this.status = GenericRequestStatus.requested,
    this.additionalData = const {},
    this.transitions,
  });
}