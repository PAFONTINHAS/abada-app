import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/errors/exception_handler.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/data/models/event_entity_model.dart';
import 'package:sistema_abada_capoeira/features/events/data/datasources/event_remote_datasource.dart';

class EventRemoteDatasourceImpl implements EventRemoteDatasource{

  final _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, EventEntity>> createEvent(EventEntity entity) async {

    try{

      final entityModel = EventEntityModel.fromEntity(entity);

      final docReference = _firestore.collection('events').doc();
      
      await docReference.set(entityModel.toMap());

      return Right(entityModel.copyWith(eventId: docReference.id));

    }catch(exception){
      return ExceptionHandler.handleException(exception: exception, contextMessage: 'createEvent');
    }

  }

  @override
  Future<Either<Failure, void>> removeEvent(String eventId) async {

    try{

      await _firestore.collection('events').doc(eventId).delete();

      return Right(null);

    }catch(exception){
      return ExceptionHandler.handleException(exception: exception, contextMessage: 'removeEvent');
    }

  }


}