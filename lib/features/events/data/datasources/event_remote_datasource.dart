import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';

abstract class EventRemoteDatasource {

  Future<Either<Failure, void>> removeEvent(String eventId);
  Future<Either<Failure, EventEntity>> createEvent(EventEntity entity);
  Future<Either<Failure, String>> uploadEventImage(File eventImage, String fileName);
  Future<Either<Failure, List<EventEntity>>> getEventsByUserId(String userId);
  Future<Either<Failure, List<EventEntity>>> getEvents();
  Future<Either<Failure, EventEntity>> getEventById(String eventId);





}