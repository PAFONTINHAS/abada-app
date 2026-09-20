//esse arquivo faz a ligação entre tela e Use Cases

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/membership_request.dart';
import '../../domain/usecases/approve_membership_request_usecase.dart';
import '../../domain/usecases/get_professor_membership_requests_usecase.dart';
import '../../domain/usecases/reject_membership_request_usecase.dart';
import '../../domain/usecases/request_membership_changes_usecase.dart';

class MembershipValidationController extends ChangeNotifier {
  //herda funcionalidades de ChangeNotifier permite usar o notifyListeners
  final GetProfessorMembershipRequestsUseCase getProfessorRequestsUsecase;
  final ApproveMembershipRequestUseCase approveMembershipRequestUsecase;
  final RequestMembershipChangesUseCase requestMembershipChangesUsecase;
  final RejectMembershipRequestUsecase rejectMembershipRequestUsecase;
  //define todas as ações do usecases

  MembershipValidationController({
    required this.getProfessorRequestsUsecase,
    required this.approveMembershipRequestUsecase,
    required this.requestMembershipChangesUsecase,
    required this.rejectMembershipRequestUsecase,
  });
  //constructor da classe

  List<MembershipRequest> requests = [];
  //lista de solicitações que o Controller vai guardar

  bool isLoading = false; //"Estamos carregando alguma coisa agora?"
  String? errorMessage; //Guarda uma mensagem caso alguma operação dê erro, podendo ser null

  //recebe a ação carregarSolicitações
  Future<void> loadRequests(String professorId) async {
    isLoading = true; //estamos carregando
    errorMessage = null; //limpando erro antigo
    notifyListeners();
    //“Provider, avise quem estiver observando este controller que alguma coisa mudou.”
    // Chama o use case responsável por buscar as solicitações
    final result = await getProfessorRequestsUsecase.call(professorId);
    result.fold(
      (failure) {
        // Se ocorreu uma falha, guarda a mensagem de erro
        errorMessage = failure.message;
      },
      (loadedRequests) {
        // Se deu certo, guarda a lista recebida
        requests = loadedRequests;
      },
    );

    isLoading = false;
    notifyListeners();
  }

  //recebe a ação aprovarSolicitação + id
  Future<bool> approve(MembershipRequest request, String professorId) async {
    errorMessage = null;
    final result = await approveMembershipRequestUsecase.call(request);
    //e chama o use case correto, o approveMembershipRequest
    final success = result.fold(
      (failure) {
        errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        return true;
      },
    );

    if(success) await loadRequests(professorId);

    isLoading = false;
    notifyListeners();
    return success;
  }

  //recebe a ação pedir correções + id + motivo
  Future<bool> requestChanges(String requestId, String changeReason, String professorId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    // Chama o use case responsável por solicitar correções
    final result = await requestMembershipChangesUsecase.call(
      requestId,
      changeReason,
    );

    // Trata os dois resultados possíveis do Either
    final success = result.fold(
      (failure) {
        // Se ocorreu uma falha, guarda a mensagem
        errorMessage = failure.message;
        return false;
      },
      (_){
        return true;
      },
    );

    if(success) await loadRequests(professorId);
    
    isLoading = false;
    notifyListeners();

    return success;
  }

  //recebe a ação rejeitarSolicitação + id + motivo
  Future<bool> reject( String requestId, String rejectReason, String professorId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    // Chama o use case responsável por rejeitar a solicitação
    final result = await rejectMembershipRequestUsecase.call(
      requestId,
      rejectReason,
    );

    // Trata os dois resultados possíveis do Either
    final bool success = result.fold(
      (failure){
        // Se ocorreu uma falha, guarda a mensagem
        errorMessage = failure.message;
        return false;
      },
      (_){
        return true;
      },
    );

    if(success) await loadRequests(professorId);

    isLoading = false;
    notifyListeners();

    return success;
  }
}

