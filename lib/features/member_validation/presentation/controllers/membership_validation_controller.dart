//esse arquivo faz a ligação entre tela e Use Cases

import 'package:flutter/foundation.dart';
import '../../domain/entities/membership_request.dart';
import '../../domain/usecases/approve_membership_request.dart';
import '../../domain/usecases/get_professor_membership_requests.dart';
import '../../domain/usecases/reject_membership_request.dart';
import '../../domain/usecases/request_membership_changes.dart';

class MembershipValidationController extends ChangeNotifier {
  //herda funcionalidades de ChangeNotifier permite usar o notifyListeners
  final GetProfessorMembershipRequests getProfessorRequests;
  final ApproveMembershipRequest approveMembershipRequest;
  final RequestMembershipChanges requestMembershipChanges;
  final RejectMembershipRequest rejectMembershipRequest;
  //define todas as ações do usecases

  MembershipValidationController({
    required this.getProfessorRequests,
    required this.approveMembershipRequest,
    required this.requestMembershipChanges,
    required this.rejectMembershipRequest,
  });
  //constructor da classe

  List<MembershipRequest> requests = [];
  //lista de solicitações que o Controller vai guardar

  bool isLoading = false; //"Estamos carregando alguma coisa agora?"
  String?
  errorMessage; //Guarda uma mensagem caso alguma operação dê erro, podendo ser null

  //recebe a ação carregarSolicitações
  Future<void> loadRequests(String professorId) async {
    isLoading = true; //estamos carregando
    errorMessage = null; //limpando erro antigo
    notifyListeners();
    //“Provider, avise quem estiver observando este controller que alguma coisa mudou.”

    try {
      requests = await getProfessorRequests(professorId);
      //e chama o use case correto, o  get
    } catch (error) {
      errorMessage = error
          .toString(); //transforma o erro em string e guarda na variavel
    } finally {
      //execute independente de sucesso ou falha
      isLoading = false; //terminou, não estamos carregando mais nada
      notifyListeners();
    }
  }

  //recebe a ação aprovarSolicitação + id
  Future<void> approve(String requestId, String professorId) async {
    await approveMembershipRequest(requestId);
    //e chama o use case correto, o approveMembershipRequest
    await loadRequests(professorId); //recarrega a lista de pendentes
  }

  //recebe a ação pedir correções + id + motivo
  Future<void> requestChanges(String requestId, String changeReason,String professorId) async {
    await requestMembershipChanges(
      requestId,
      changeReason,
      //e chama o use case correto, o requestMembershipChanges
    );
        await loadRequests(professorId); //recarrega a lista de pendentes
  }

  //recebe a ação rejeitarSolicitação + id + motivo
  Future<void> reject(String requestId, String rejectReason, String professorId) async {
    await rejectMembershipRequest(
      requestId,
      rejectReason,
      //e chama o use case correto, o rejectMembershipRequest
    );
    await loadRequests(professorId); //recarrega a lista de pendentes
  }
}
