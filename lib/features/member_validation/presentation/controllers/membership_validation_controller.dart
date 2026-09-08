//esse arquivo faz a ligação entre tela e Use Cases

import 'package:flutter/foundation.dart';
import '../../domain/entities/membership_request.dart';
import '../../domain/usecases/approve_membership_request_usecase.dart';
import '../../domain/usecases/get_professor_membership_requests_usecase.dart';
import '../../domain/usecases/reject_membership_request_usecase.dart';
import '../../domain/usecases/request_membership_changes_usecase.dart';

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
  String? errorMessage; //Guarda uma mensagem caso alguma operação dê erro, podendo ser null

  //recebe a ação carregarSolicitações
  Future<void> loadRequests(String professorId) async {
    isLoading = true; //estamos carregando
    errorMessage = null; //limpando erro antigo
    notifyListeners();
    //“Provider, avise quem estiver observando este controller que alguma coisa mudou.”
    try {
      // Chama o use case responsável por buscar as solicitações
      final result = await getProfessorRequests(professorId);
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
    } catch (error) {
      // Captura alguma exceção inesperada que não foi tratada pelo Either
      errorMessage = error.toString();
    } finally {
      // Executa independentemente de sucesso ou falha
      isLoading = false; // Terminou o carregamento
      notifyListeners(); // Avisa a interface para atualizar
    }
  }

  //recebe a ação aprovarSolicitação + id
  Future<bool> approve(String requestId, String professorId) async {
    errorMessage = null;
    final result = await approveMembershipRequest(requestId);
    //e chama o use case correto, o approveMembershipRequest
    final success = await result.fold(
      (failure) async {
        errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) async {
        await loadRequests(professorId); //recarrega a lista de pendentes
        return true;
      },
    );
      isLoading = false;
      notifyListeners();
      return success;
  }

  //recebe a ação pedir correções + id + motivo
  Future<bool> requestChanges( String requestId, String changeReason, String professorId,
  ) async {
  isLoading = true;
  errorMessage = null;
  notifyListeners();

  try {
    // Chama o use case responsável por solicitar correções
    final result = await requestMembershipChanges(
      requestId,
      changeReason,
    );

    // Trata os dois resultados possíveis do Either
    final success = await result.fold(
      (failure) async {
        // Se ocorreu uma falha, guarda a mensagem
        errorMessage = failure.message;
        return false;
      },
      (_) async {
        // Se deu certo, recarrega a lista de solicitações
        await loadRequests(professorId);
        return true;
      },
    );
    return success;
  } catch (error) {
    // Captura exceções inesperadas
    errorMessage = error.toString();
    return false;
  } finally {
    // Executa independentemente de sucesso ou falha
    isLoading = false;
    notifyListeners();
  }
}
  //recebe a ação rejeitarSolicitação + id + motivo
  Future<bool> reject( String requestId, String rejectReason, String professorId,
  ) async {
  isLoading = true;
  errorMessage = null;
  notifyListeners();

  try {
    // Chama o use case responsável por rejeitar a solicitação
    final result = await rejectMembershipRequest(
      requestId,
      rejectReason,
    );

    // Trata os dois resultados possíveis do Either
    final success = await result.fold(
      (failure) async {
        // Se ocorreu uma falha, guarda a mensagem
        errorMessage = failure.message;
        return false;
      },
      (_) async {
        // Se deu certo, recarrega a lista de solicitações
        await loadRequests(professorId);
        return true;
      },
    );

    return success;
  } catch (error) {
    // Captura exceções inesperadas
    errorMessage = error.toString();
    return false;
  } finally {
    // Executa independentemente de sucesso ou falha
    isLoading = false;
    notifyListeners();
    }
  }
}

