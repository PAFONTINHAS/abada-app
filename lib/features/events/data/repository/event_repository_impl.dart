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

  EventRequestsRemoteDatasource eventRequestsRemoteDatasource;
  EventRemoteDatasource eventRemoteDatasource;

  EventRepositoryImpl(this.eventRequestsRemoteDatasource, this.eventRemoteDatasource);

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
    return await eventRequestsRemoteDatasource.createEventRequest(params);
  }

  @override
  Future<Either<Failure, void>> approveRequest(GenericRequestUpdateParameters params) async{
    return await eventRequestsRemoteDatasource.approveRequest(params);
  } 

  @override
  Future<Either<Failure, void>> rejectRequest(GenericRequestUpdateParameters params) async{
    return await eventRequestsRemoteDatasource.rejectRequest(params);
  }

  @override
  Future<Either<Failure, void>> requestChanges(GenericRequestUpdateParameters params) async{
    return await eventRequestsRemoteDatasource.requestChanges(params);
  }

  @override
  Future<Either<Failure, void>> markRequestAsUpdated(GenericRequestUpdateParameters params) async{
    return await eventRequestsRemoteDatasource.markRequestAsUpdated(params);
  }

  @override
  Future<Either<Failure, String>> uploadEventImage(File eventImage, String fileName) async {
    return await eventRemoteDatasource.uploadEventImage(eventImage, fileName);
  }

  @override
  Future<Either<Failure, List<EventEntity>>> getEvents() async{
    return await eventRemoteDatasource.getEvents();
  }

  @override
  Future<Either<Failure, List<EventEntity>>> getEventsByUserId(String userId) async{
    return await eventRemoteDatasource.getEventsByUserId(userId);
  }

  @override
  Future<Either<Failure, List<EventRequestEntity>>> getPendingEventsRequestsByUserId(String userId) async{
    return await eventRequestsRemoteDatasource.getPendingEventsRequestsByUserId(userId);
  }

  @override
  Future<Either<Failure, List<EventRequestEntity>>> getPendingEventsRequests() async{
    return await eventRequestsRemoteDatasource.getPendingEventsRequests();
  }

  @override
  Future<Either<Failure, EventEntity>> getEventById(String eventId) async{
    return await eventRemoteDatasource.getEventById(eventId);
  }

}