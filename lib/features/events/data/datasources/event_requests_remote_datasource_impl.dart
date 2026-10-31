import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/errors/exception_handler.dart';
import 'package:sistema_abada_capoeira/core/constants/database_constants.dart';
import 'package:sistema_abada_capoeira/core/requests/data/request_datasource_impl.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/data/models/event_request_entity_model.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_update_parameters.dart';
import 'package:sistema_abada_capoeira/features/events/data/datasources/event_requests_remote_datasource.dart';

class EventRequestsRemoteDatasourceImpl extends RequestDatasourceImpl implements EventRequestsRemoteDatasource{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  @override 
  Future<Either<Failure, List<EventRequestEntity>>> getPendingEventsRequestsByUserId(String userId) async{
    try{

      final QuerySnapshot query = await _firestore
        .collection(DBCollections.eventsRequestsCollection)
        .where('status', isNotEqualTo: 'approved')
        .where('requesterId', isEqualTo: userId)
        .get();

      final List<EventRequestEntity> pendingRequests = query.docs
        .map((document) => EventRequestEntityModel.fromSnapshot(document))
        .toList();

      return Right(pendingRequests);

    }catch(exception){
      return ExceptionHandler.handleException(exception: exception, contextMessage: "getPendingEventsRequestsByUserId");
    }
  }
  
  @override
  Future<Either<Failure, List<EventRequestEntity>>> getPendingEventsRequests() async{
    try{

      final QuerySnapshot query = await _firestore
        .collection(DBCollections.eventsRequestsCollection)
        .where('status', isEqualTo: 'requested')
        .get();

      final List<EventRequestEntity> pendingRequests = query.docs
        .map((document) => EventRequestEntityModel.fromSnapshot(document))
        .toList();

      return Right(pendingRequests);
    }catch(exception){
      return ExceptionHandler.handleException(exception: exception, contextMessage: "getPendingEventsRequests");
    }
  }

  @override
  Future<Either<Failure, EventRequestEntity>> createEventRequest(EventRequestEntity params) async{

    try{
      final documentReference = _firestore.collection(DBCollections.eventsRequestsCollection).doc();

      await documentReference.set(params.toMap());

      return Right(params.copyWith(requestId: documentReference.id));

    }catch(exception){

      return ExceptionHandler.handleException(exception: exception, contextMessage: "createEventRequest");

    }

  }

  @override
  Future<Either<Failure, void>> approveRequest(
    GenericRequestUpdateParameters params,
  ) => approveGenericRequest(DBCollections.eventsRequestsCollection, params);

  @override
  Future<Either<Failure, void>> rejectRequest(
    GenericRequestUpdateParameters params,
  ) => rejectGenericRequest(DBCollections.eventsRequestsCollection, params);

  @override
  Future<Either<Failure, void>> requestChanges(
    GenericRequestUpdateParameters params,
  ) => requestGenericChanges(DBCollections.eventsRequestsCollection, params);

  @override
  Future<Either<Failure, void>> markRequestAsUpdated(
    GenericRequestUpdateParameters params,
  ) {
    return updateGenericRequest(
      DBCollections.eventsRequestsCollection,
      params,
      GenericRequestStatus.updated,
      additionalData: {'updatedAt': FieldValue.serverTimestamp()},
    );
  }
  
}