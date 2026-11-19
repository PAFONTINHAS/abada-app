
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';

class GenericRequestCreationParameters {
  //atibutos de uma solicitação
  final String requestId;
  final String rejectionReason;
  final String changeReason;
  final DateTime requestedAt;
  final DateTime? updatedAt; //pode ser nulo, pq só vai existir se prof pedir correções e o aluno corrigir
  final GenericRequestStatus status;

  const GenericRequestCreationParameters({
    //começa com esses valores de atributos, nao obg pq depende de ação de prof
    required this.requestId,
    required this.requestedAt, 
    this.rejectionReason = '',
    this.changeReason = '',
    this.updatedAt,
    this.status = GenericRequestStatus.requested, //se nao passar nada começa requested
  });


}