//interface, define o que precisa ser feito= contrato
//Esse arquivo ainda não tem Firebase dentro.
//Ele só define quais operações a camada data precisa oferecer.
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../model/membership_request_model.dart';
import 'package:sistema_abada_capoeira/features/member_validation/domain/entities/membership_request.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_update_parameters.dart';

abstract class MembershipValidationRemoteDataSource {
  Future<Either<Failure, List<MembershipRequestModel>>> getProfessorRequests(
    String professorId,
  );

  Future<Either<Failure, void>> approveRequest(GenericRequestUpdateParameters params);

  Future<Either<Failure, void>> requestChanges(GenericRequestUpdateParameters params);

  Future<Either<Failure, void>> rejectRequest(GenericRequestUpdateParameters params);

  Future<Either<Failure, void>> markRequestAsUpdated(
    GenericRequestUpdateParameters params,
  );

  Future<Either<Failure, void>> createMembershipRequest(
    MembershipRequest request,
  );
}
