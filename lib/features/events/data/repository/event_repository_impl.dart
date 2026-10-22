import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/repository/event_repository.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/data/datasources/event_remote_datasource.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_update_parameters.dart';
import 'package:sistema_abada_capoeira/features/events/data/datasources/event_requests_remote_datasource.dart';

class EventRepositoryImpl implements EventRepository{

  EventRequestsRemoteDatasource requestRemoteDatasource;
  EventRemoteDatasource eventRemoteDatasource;

  EventRepositoryImpl(this.requestRemoteDatasource, this.eventRemoteDatasource);

  @override
  Future<Either<Failure, EventEntity>> createEvent(EventEntity entity) async{
    return await eventRemoteDatasource.createEvent(entity);
  }
  @override
  Future<Either<Failure, void>> removeEvent(String eventId) async{
    return await eventRemoteDatasource.removeEvent(eventId);
  }
  @override
  Future<Either<Failure, EventRequestEntity>> createEventRequest(EventRequestEntity params) async{
    return await requestRemoteDatasource.createEventRequest(params);
  }
  @override
  Future<Either<Failure, void>> approveRequest(GenericRequestUpdateParameters params) async{
    return await requestRemoteDatasource.approveRequest(params);
  } 
  @override
  Future<Either<Failure, void>> rejectRequest(GenericRequestUpdateParameters params) async{
    return await requestRemoteDatasource.rejectRequest(params);
  }
  @override
  Future<Either<Failure, void>> requestChanges(GenericRequestUpdateParameters params) async{
    return await requestRemoteDatasource.requestChanges(params);
  }
  @override
  Future<Either<Failure, void>> markRequestAsUpdated(GenericRequestUpdateParameters params) async{
    return await requestRemoteDatasource.markRequestAsUpdated(params);
  }

  @override
  Future<Either<Failure, String>> uploadEventImage(File eventImage, String fileName) async {

    return await eventRemoteDatasource.uploadEventImage(eventImage, fileName);

  }



}