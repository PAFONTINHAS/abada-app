import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sistema_abada_capoeira/core/errors/exception_handler.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/requests/data/request_datasource_impl.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_update_parameters.dart';
import 'package:sistema_abada_capoeira/features/events/data/datasources/event_requests_remote_datasource.dart';
import 'package:sistema_abada_capoeira/features/events/data/models/event_entity_model.dart';
import 'package:sistema_abada_capoeira/features/events/data/models/event_request_entity_model.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_policy.dart';

class EventRequestsRemoteDatasourceImpl extends RequestDatasourceImpl
    implements EventRequestsRemoteDatasource {
  final String _requestCollectionId = 'event_requests';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<Either<Failure, EventRequestEntity>> getEventRequestById(String requestId,) async {
    try {
      final snapshot = await _firestore
          .collection(_requestCollectionId)
          .doc(requestId)
          .get();

      if (!snapshot.exists) {
        return const Left(
          ValidationFailure('Solicitação de evento não encontrada.'),
        );
      }
      return Right(EventRequestEntityModel.fromSnapshot(snapshot));
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'getEventRequestById',
      );
    }
  }

  @override
  Future<Either<Failure, List<EventRequestEntity>>> getEventRequestsByUserId( String userId,) async {
    try {
      final QuerySnapshot query = await _firestore
          .collection(_requestCollectionId)
          .where('status', isNotEqualTo: 'approved')
          .where('requesterId', isEqualTo: userId)
          .get();

      final List<EventRequestEntity> pendingRequests = query.docs
          .map((document) => EventRequestEntityModel.fromSnapshot(document))
          .toList();

      return Right(pendingRequests);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'getEventRequestsByUserId',
      );
    }
  }

  @override
  Future<Either<Failure, List<EventRequestEntity>>>getPendingEventsRequests() async {
    try {
      final QuerySnapshot query = await _firestore
          .collection(_requestCollectionId)
          .where('status', whereIn: ['requested', 'updated'])
          .get();

      final List<EventRequestEntity> pendingRequests = query.docs
          .map((document) => EventRequestEntityModel.fromSnapshot(document))
          .toList();

      return Right(pendingRequests);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'getPendingEventsRequests',
      );
    }
  }

  @override
  Future<Either<Failure, EventRequestEntity>> createEventRequest(EventRequestEntity params,) async {
    try {
      final documentReference = _firestore
          .collection(_requestCollectionId)
          .doc();

      await documentReference.set(params.toMap());
      return Right(params.copyWith(requestId: documentReference.id));
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'createEventRequest',
      );
    }
  }

  @override
  Future<Either<Failure, void>> approveRequest(GenericRequestUpdateParameters params,) =>
      _updateDecisionTransaction(params,GenericRequestStatus.approved,
        const {
          GenericRequestStatus.requested: GenericRequestStatus.approved,
          GenericRequestStatus.updated: GenericRequestStatus.approved,
        },
      );

  @override
  Future<Either<Failure, void>> rejectRequest(GenericRequestUpdateParameters params,) =>
      _updateDecisionTransaction(
        params,
        GenericRequestStatus.rejected,
        params.transitions,
      );

  @override
  Future<Either<Failure, void>> requestChanges(GenericRequestUpdateParameters params,) =>
      _updateDecisionTransaction(
        params,
        GenericRequestStatus.changesRequested,
        params.transitions,
      );

  // O reenvio atualiza o evento e a solicitação na mesma transação.
  @override
  Future<Either<Failure, void>> markRequestAsUpdated(GenericRequestUpdateParameters params,) async =>
      const Left(ValidationFailure('Utilize o reenvio transacional do evento.'),);

  Future<Either<Failure, void>> _updateDecisionTransaction(
    GenericRequestUpdateParameters params,
    GenericRequestStatus destination,
    Map<GenericRequestStatus, GenericRequestStatus>? transitions,
  ) async {
    if (transitions == null || transitions.isEmpty) {
      return const Left(ValidationFailure('Transições da decisão não informadas.'),);
    }

    final userId = _auth.currentUser?.uid;
    final reason = destination == GenericRequestStatus.rejected
        ? params.rejectionReason.trim()
        : params.changeReason.trim();

    return updateGenericRequestWithTransaction(
      collectionId: _requestCollectionId,
      params: params,
      transitions: transitions,
      updateRelatedDocuments: (transaction, requestSnapshot) async {
        transaction.update(requestSnapshot.reference, {
          if (destination == GenericRequestStatus.rejected)
            'rejectionReason': reason,
          if (destination == GenericRequestStatus.changesRequested)
            'changeReason': reason,
          'decidedBy': userId,
          'decidedByName': params.additionalData['decidedByName'] ?? '',
          'decidedAt': FieldValue.serverTimestamp(),
        });
      },
    );
  }

  // Atualiza os dados permitidos de um evento com solicitação aberta.
  // Preserva os IDs e as datas. O destino depende do status na transação.
  @override
  Future<Either<Failure, GenericRequestStatus>> resubmitEventRequest(
    String requestId,
    EventEntity event,
  ) async {
    try {
      final eventReference = _firestore.collection('events').doc(event.eventId);
      final eventModel = EventEntityModel.fromEntity(event);

      GenericRequestStatus? persistedStatus;
      final result = await updateGenericRequestWithTransaction(
        collectionId: _requestCollectionId,
        params: GenericRequestUpdateParameters(requestId: requestId),
        transitions: EventRequestPolicy.editingTransitions,
        updateRelatedDocuments: (transaction, requestSnapshot) async {
          final requestData = requestSnapshot.data();
          final source = GenericRequestStatusExtension.fromString(
            requestData?['status'] as String? ?? '',
          );
          persistedStatus = EventRequestPolicy.editingTransitions[source];

          final eventSnapshot = await transaction.get(eventReference);

          if (!eventSnapshot.exists) {
            throw StateError('Evento não encontrado.');
          }

          final existingEventData = eventSnapshot.data();
          final eventData = eventModel.toMap();
          eventData['eventName'] = event.eventName.trim();

          // Preserva a imagem existente quando nenhuma nova é informada.
          if (eventData['eventImagePath'] == null) {
            eventData['eventImagePath'] = existingEventData?['eventImagePath'];
          }

          final updates = <String, dynamic>{};
          for (final field in EventRequestPolicy.editableFields) {
            if (eventData.containsKey(field)) {
              updates[field] = eventData[field];
            }
          }

          transaction.update(eventReference, updates);
          transaction.update(requestSnapshot.reference, {
            'eventName': event.eventName.trim(),
          });
        },
      );

      return result.map((_) => persistedStatus!);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'resubmitEventRequest',
      );
    }
  }
}