import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/core/errors/exception_handler.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/core/requests/data/request_datasource_impl.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/features/events/data/models/event_request_entity_model.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/data/datasources/event_requests_remote_datasource.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_update_parameters.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/data/models/event_entity_model.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_policy.dart';

class EventRequestsRemoteDatasourceImpl extends RequestDatasourceImpl
    implements EventRequestsRemoteDatasource {
  final String _requestCollectionId = "event_requests";
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  EventRequestsRemoteDatasourceImpl({super.firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<Either<Failure, List<EventRequestEntity>>>
  getPendingEventsRequestsByUserId(String userId) async {
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
        contextMessage: "getPendingEventsRequestsByUserId",
      );
    }
  }

  @override
  Future<Either<Failure, List<EventRequestEntity>>>
  getPendingEventsRequests() async {
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
        contextMessage: "getPendingEventsRequests",
      );
    }
  }

  @override
  Future<Either<Failure, EventRequestEntity>> createEventRequest(
    EventRequestEntity params,
  ) async {
    try {
      final documentReference = _firestore
          .collection(_requestCollectionId)
          .doc();

      await documentReference.set(params.toMap());

      return Right(params.copyWith(requestId: documentReference.id));
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: "createEventRequest",
      );
    }
  }

  @override
  Future<Either<Failure, void>> approveRequest(
    GenericRequestUpdateParameters params,
  ) => _decide(params, GenericRequestStatus.approved);

  @override
  Future<Either<Failure, void>> rejectRequest(
    GenericRequestUpdateParameters params,
  ) => _decide(params, GenericRequestStatus.rejected);

  @override
  Future<Either<Failure, void>> requestChanges(
    GenericRequestUpdateParameters params,
  ) => _decide(params, GenericRequestStatus.changesRequested);

  // Reenviar exige atualizar evento e solicitação juntos. Não há atalho de status.
  @override
  Future<Either<Failure, void>> markRequestAsUpdated(
    GenericRequestUpdateParameters params,
  ) async => const Left(
    ValidationFailure('Utilize o reenvio transacional do evento.'),
  );

  Future<Either<Failure, void>> _decide(
    GenericRequestUpdateParameters params,
    GenericRequestStatus destination,
  ) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null || params.requestId.trim().isEmpty) {
      return const Left(
        UnauthorizedFailure('Usuário não autenticado ou solicitação inválida.'),
      );
    }
    final reason = destination == GenericRequestStatus.rejected
        ? params.rejectionReason.trim()
        : params.changeReason.trim();
    if (destination != GenericRequestStatus.approved && reason.isEmpty) {
      return const Left(ValidationFailure('Informe o motivo da decisão.'));
    }
    return updateGenericRequestWithTransaction(
      collectionId: _requestCollectionId,
      params: params,
      transitions: {
        GenericRequestStatus.requested: destination,
        GenericRequestStatus.updated: destination,
      },
      updateRelatedDocuments: (transaction, requestSnapshot) async {
        final user = await transaction.get(
          _firestore.collection('users').doc(userId),
        );
        if (user.data()?['userRole'] != 'coordinator' ||
            user.data()?['isActive'] == false) {
          throw StateError(
            'Somente coordenadores ativos podem analisar eventos.',
          );
        }
        final request = requestSnapshot.data()!;
        final eventId = request['eventId'];
        if (eventId is! String || eventId != params.additionalData['eventId']) {
          throw StateError('Evento e solicitação não correspondem.');
        }
        final event = await transaction.get(
          _firestore.collection('events').doc(eventId),
        );
        if (!event.exists ||
            event.data()?['eventCreatorId'] != request['requesterId']) {
          throw StateError(
            'Autoria do evento e da solicitação não corresponde.',
          );
        }
        transaction.update(requestSnapshot.reference, {
          if (destination == GenericRequestStatus.rejected)
            'rejectionReason': reason,
          if (destination == GenericRequestStatus.changesRequested)
            'changeReason': reason,
          'decidedBy': userId,
          'decidedByName':
              user.data()?['nickname'] ?? user.data()?['fullName'] ?? '',
          'decidedAt': FieldValue.serverTimestamp(),
        });
      },
    );
  }

  // Atualiza os dados permitidos de um evento com solicitação aberta.
  // Preserva os IDs e as datas; o destino depende da origem na transação.
  // A alteração de datas será tratada separadamente pela RF19.
  @override
  Future<Either<Failure, GenericRequestStatus>> resubmitEventRequest(
    String requestId,
    EventEntity event,
  ) async {
    try {
      final userId = _auth.currentUser?.uid;

      if (userId == null) {
        return const Left(ValidationFailure('Usuário não autenticado.'));
      }

      if (requestId.trim().isEmpty || event.eventId.trim().isEmpty) {
        return const Left(
          ValidationFailure('ID da solicitação ou do evento inválido.'),
        );
      }

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

          if (requestData == null ||
              requestData['requesterId'] != userId ||
              requestData['eventId'] != event.eventId) {
            throw StateError(
              'A solicitação não pertence ao usuário ou ao evento informado.',
            );
          }

          final actor = await transaction.get(
            _firestore.collection('users').doc(userId),
          );
          if (actor.data()?['userRole'] != 'professor' ||
              actor.data()?['isActive'] == false) {
            throw StateError(
              'Somente professores ativos podem editar seus eventos.',
            );
          }
          final eventSnapshot = await transaction.get(eventReference);

          if (!eventSnapshot.exists) {
            throw StateError('Evento não encontrado.');
          }

          final existingEventData = eventSnapshot.data();

          if (existingEventData?['eventCreatorId'] != userId) {
            throw StateError(
              'O usuário não possui permissão para editar este evento.',
            );
          }

          // Converte os dados do evento para atualização.
          final eventData = eventModel.toMap();
          eventData['eventName'] = event.eventName.trim();

          // Preserva a imagem existente caso nenhuma nova seja informada.
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
