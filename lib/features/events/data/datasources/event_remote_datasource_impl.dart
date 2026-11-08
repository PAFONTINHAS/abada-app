import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/services/image_service.dart';
import 'package:sistema_abada_capoeira/core/errors/exception_handler.dart';
import 'package:sistema_abada_capoeira/core/constants/database_constants.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/data/models/event_entity_model.dart';
import 'package:sistema_abada_capoeira/features/events/data/datasources/event_remote_datasource.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_subscription_entity.dart';
import 'package:sistema_abada_capoeira/features/events/data/models/event_subscription_entity_model.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/events_and_user_subscriptions.dart';

class EventRemoteDatasourceImpl implements EventRemoteDatasource{

  final _firestore = FirebaseFirestore.instance;
  final ImageService _imageService = ImageService();

  @override
  Future<Either<Failure, EventEntity>> getEventById(String eventId) async{
    try{
      
      final DocumentSnapshot document = await _firestore.collection(DBCollections.ongoingEventsCollection).doc(eventId).get();

      final entityModel = EventEntityModel.fromSnapshot(document);

      return Right(entityModel);

    } catch(exception){
      return ExceptionHandler.handleException(exception: exception, contextMessage: 'getEventsByUserId');
    }
  }

  @override
  Future<Either<Failure, List<EventEntity>>> getEventsByUserId(String userId) async{
    try{
      
      final QuerySnapshot query = await _firestore
          .collection(DBCollections.ongoingEventsCollection)
          .where('eventActive', isEqualTo: true)
          .where('eventCreatorId', isEqualTo: userId)
          .get();

      final eventsList = query.docs.map((document) => EventEntityModel.fromSnapshot(document)).toList();

      return Right(eventsList);

    } catch(exception){
      return ExceptionHandler.handleException(exception: exception, contextMessage: 'getEventsByUserId');
    }
  }

  @override
  Future<Either<Failure, EventsAndUserSubscriptions>> getEventsAndSubscriptions(String userId) async{
    try{

      final List<DocumentSnapshot> userSubscriptions = []; 
      final QuerySnapshot query = await _firestore
          .collection(DBCollections.ongoingEventsCollection)
          .where('eventActive', isEqualTo: true)
          .where('finishedEvent', isEqualTo: false)
          .get();

      for(final document in query.docs){
        
        if(document.data() == null) continue;
        
        final subscriptionDoc = await _firestore
          .collection(DBCollections.ongoingEventsCollection)
          .doc(document.id)
          .collection(DBCollections.eventSubscriptionsCollection)
          .doc(userId)
          .get();

        if(!subscriptionDoc.exists || subscriptionDoc.data() == null) continue;


        if(subscriptionDoc.exists && document.data() != null){

          userSubscriptions.add(subscriptionDoc);
        } 
      }

      final eventsList = query.docs
          .map((document) => EventEntityModel.fromSnapshot(document))
          .toList();
      final subscriptionsList = userSubscriptions
          .map((document) => EventSubscriptionEntityModel.fromSnapshot(document))
          .toList();


      return Right(
        EventsAndUserSubscriptions(
          events: eventsList,
          userSubscriptions: subscriptionsList,
        ),
      );

    } catch(exception){
      return ExceptionHandler.handleException(exception: exception, contextMessage: 'getEvents');
    }
  }

  
  @override
  Future<Either<Failure, String>> uploadEventImage(File eventImage, String fileName) async {
    try{

      final String? imagePath = await _imageService.uploadEventImage(eventImage, fileName, imageCollection: "events");

      if(imagePath == null) return Left(UnknownFailure("Erro ao salvar a imagem do evento"));

      return Right(imagePath);

    }catch(exception){
      return ExceptionHandler.handleException(exception: exception, contextMessage: 'createEvent');
    }

  }

  @override
  Future<Either<Failure, EventEntity>> createEvent(EventEntity entity) async {
    try{

      final entityModel = EventEntityModel.fromEntity(entity);

      final docReference = _firestore.collection(DBCollections.ongoingEventsCollection).doc();
      
      await docReference.set(entityModel.toMap());

      return Right(entityModel.copyWith(eventId: docReference.id));

    }catch(exception){
      return ExceptionHandler.handleException(exception: exception, contextMessage: 'createEvent');
    }

  }

  @override
  Future<Either<Failure, void>> removeEvent(String eventId) async {
    try{
      await _firestore.collection(DBCollections.ongoingEventsCollection).doc(eventId).delete();

      return Right(null);

    }catch(exception){
      return ExceptionHandler.handleException(exception: exception, contextMessage: 'removeEvent');
    }

  }

  @override
  Future<Either<Failure, EventSubscriptionEntity>> subscribeToEvent(EventSubscriptionEntity subscription) async{
    try{

      final subscriptionModel = EventSubscriptionEntityModel.fromEntity(subscription);

      final collectionReference = _firestore
          .collection(DBCollections.ongoingEventsCollection)
          .doc(subscription.eventId)
          .collection(DBCollections.eventSubscriptionsCollection)
          .doc(subscription.userId);
      
      await collectionReference.set(subscriptionModel.toMap());

      return Right(subscription.copyWith(id: collectionReference.id));

    }catch(exception){

      return ExceptionHandler.handleException(exception: exception, contextMessage: "subscribeToEvent");
    }
  }

  @override
  Future<Either<Failure, EventSubscriptionEntity?>> validateEventSubscriptionAvailability(String userId, String eventId) async{
    try{

      final subscriptionDocument = await _firestore
          .collection(DBCollections.ongoingEventsCollection)
          .doc(eventId)
          .collection(DBCollections.eventSubscriptionsCollection)
          .doc(userId)
          .get();

      if(!subscriptionDocument.exists) return Right(null);

      final model = EventSubscriptionEntityModel.fromSnapshot(subscriptionDocument);

      return Right(model);

    }catch(exception){
      return ExceptionHandler.handleException(exception: exception, contextMessage: "getEventSubscriptionByUserAndEventId");
    }


  }
  

}