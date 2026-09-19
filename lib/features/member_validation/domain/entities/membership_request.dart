import 'membership_request_status.dart';

//solicitação de cadastro do aluno/afiliado
class MembershipRequest {
  final String id; //id da solicitação
  final String memberName;
  final String classId; //id da turma
  final String memberId; //id do membro
  final String memberNickname;
  final String className;
  final String professorId; //id do professor
  final DateTime requestedAt; //horario que o membro se cadastrou, é usado em todas as solicitações - PROF
  final String memberBelt;

  final MembershipRequestStatus status;
  final String? rejectionReason; // opcional até ele for rejeitado
  final String? changeReason; // opcional até que ele peça pro membro corrigir corda ou apelido
  final DateTime? updatedAt; //hr da ultima atualização depois da correção, é usado em todas as solicitações - PROF


  const MembershipRequest({
    this.updatedAt,
    this.changeReason,
    this.rejectionReason,

    required this.id,
    required this.status,
    required this.classId,
    required this.memberId,
    required this.className,
    required this.memberBelt,
    required this.memberName,
    required this.professorId,
    required this.requestedAt,
    required this.memberNickname,

  });
}