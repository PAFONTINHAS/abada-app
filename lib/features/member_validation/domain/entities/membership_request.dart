import 'membership_request_status.dart';

//solicitação de cadastro do aluno/afiliado
class MembershipRequest {
  final String id; //id da solicitação
  final String memberId; //id do membro
  final String professorId; //id do professor
  final String classId; //id da turma
  final DateTime requestedAt; //horario que o membro se cadastrou, é usado em todas as solicitações - PROF

  final MembershipRequestStatus status;
  final String? rejectionReason; // opcional até ele for rejeitado
  final String? changeReason; // opcional até que ele peça pro membro corrigir corda ou apelido
  final DateTime? updatedAt; //hr da ultima atualização depois da correção, é usado em todas as solicitações - PROF


  const MembershipRequest({
    required this.id,
    required this.memberId,
    required this.professorId,
    required this.classId,
    required this.status,
    this.rejectionReason,
    this.changeReason,
    required this.requestedAt,
    this.updatedAt,
  });
}