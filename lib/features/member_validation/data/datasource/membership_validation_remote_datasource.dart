//interface, define o que precisa ser feito= contrato
//Esse arquivo ainda não tem Firebase dentro.
//Ele só define quais operações a camada data precisa oferecer.
import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/requests/data/request_datasource_impl.dart';
import 'package:sistema_abada_capoeira/features/member_validation/domain/entities/membership_request.dart';
import '../../../../core/errors/failure.dart';
import '../model/membership_request_model.dart';

abstract class MembershipValidationRemoteDataSource {
  Future<Either<Failure, List<MembershipRequestModel>>> getProfessorRequests(
    String professorId,
  );

  Future<Either<Failure, void>> approveRequest(GenericRequestParameters params);

  Future<Either<Failure, void>> requestChanges(GenericRequestParameters params);

  Future<Either<Failure, void>> rejectRequest(GenericRequestParameters params);

  Future<Either<Failure, void>> markRequestAsUpdated(
    GenericRequestParameters params,
  );

  Future<Either<Failure, void>> createMembershipRequest(
    MembershipRequest request,
  );
}
