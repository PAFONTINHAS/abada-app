//interface, define o que precisa ser feito= contrato
//Esse arquivo ainda não tem Firebase dentro.
//Ele só define quais operações a camada data precisa oferecer.
import '../model/membership_request_model.dart';

abstract class MembershipValidationRemoteDataSource {
  Future<List<MembershipRequestModel>> getProfessorRequests(
    String professorId,
  );

  Future<void> approveRequest(String requestId,);

  Future<void> requestChanges(String requestId, String changesReason,);

  Future<void> rejectRequest(String requestId, String requestReason,);

  Future<void> markRequestAsUpdated(String requestId,);
}