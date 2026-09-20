//interface, define o que precisa ser feito= contrato
//Esse arquivo ainda não tem Firebase dentro.
//Ele só define quais operações a camada data precisa oferecer.
import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/features/member_validation/domain/entities/membership_request.dart';
import '../../../../core/errors/failure.dart';
import '../model/membership_request_model.dart';

abstract class MembershipValidationRemoteDataSource {
  Future<Either<Failure, List<MembershipRequestModel>>> getProfessorRequests(String professorId);

  Future<Either<Failure, void>> approveRequest(String requestId,);

  Future<Either<Failure, void>> requestChanges(String requestId, String changesReason,);

  Future<Either<Failure, void>> rejectRequest(String requestId, String requestReason,);

  Future<Either<Failure, void>> markRequestAsUpdated(String requestId,);

  Future<Either<Failure, void>> createMembershipRequest (MembershipRequest request);

}