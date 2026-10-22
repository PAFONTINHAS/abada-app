import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_update_parameters.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';

abstract class EventRequestsRemoteDatasource {

  Future<Either<Failure, EventRequestEntity>> createEventRequest(EventRequestEntity params);

  Future<Either<Failure, void>> approveRequest(GenericRequestUpdateParameters params); 

  Future<Either<Failure, void>> rejectRequest(GenericRequestUpdateParameters params);

  Future<Either<Failure, void>> requestChanges(GenericRequestUpdateParameters params);

  Future<Either<Failure, void>> markRequestAsUpdated(GenericRequestUpdateParameters params);
}