import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/errors/exception_handler.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/data/datasources/event_cancellation_remote_datasource.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/data/models/event_cancellation_request_model.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/domain/entities/event_cancellation_request_entity.dart';

class EventCancellationRemoteDatasourceImpl
    implements EventCancellationRemoteDatasource {
  EventCancellationRemoteDatasourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _requests =>
      _firestore.collection('event_cancellation_requests');

  @override
  Future<Either<Failure, EventCancellationRequestEntity>> requestCancellation(
    EventCancellationRequestEntity request,
  ) async {
    try {
      final requestReference = _requests.doc();
      final eventReference = _firestore
          .collection('events')
          .doc(request.eventId);
      final batch = _firestore.batch();
      final eventSnapshot = await eventReference.get();
      final eventData = eventSnapshot.data() ?? {};
      final participantIds = List<String>.from(
        eventData['enrolledParticipantIds'] as List? ??
            eventData['participantIds'] as List? ??
            [],
      );
      final participantCount =
          (eventData['enrolledParticipants'] as num?)?.toInt() ??
          participantIds.length;
      final refundTicketIds = request.refundRequired
          ? List.generate(
              participantCount,
              (index) => '${requestReference.id}-${index + 1}',
            )
          : <String>[];

      final eventUpdates = <String, dynamic>{
        'registrationsEnabled': false,
        'cancellationRequested': true,
        'cancellationRequestedAt': FieldValue.serverTimestamp(),
      };
      if (!eventSnapshot.exists) {
        eventUpdates['creatorId'] = request.creatorId;
        eventUpdates['title'] = request.eventTitle;
      }
      batch.set(eventReference, eventUpdates, SetOptions(merge: true));

      final model = EventCancellationRequestModel(
        id: requestReference.id,
        eventId: request.eventId,
        eventTitle: request.eventTitle,
        requesterId: request.requesterId,
        creatorId: request.creatorId,
        reason: request.reason,
        details: request.details,
        requestedAt: request.requestedAt,
        refundRequired: request.refundRequired,
        refundTicketIds: refundTicketIds,
      );
      batch.set(requestReference, model.toMap());
      if (request.refundRequired) {
        for (var index = 0; index < participantCount; index++) {
          final ticketReference = _firestore
              .collection('refund_tickets')
              .doc('${requestReference.id}-${index + 1}');
          batch.set(ticketReference, {
            'requestId': requestReference.id,
            'eventId': request.eventId,
            'participantId': index < participantIds.length
                ? participantIds[index]
                : null,
            'participantNumber': index + 1,
            'preferredPaymentMethod': 'PIX',
            'status': 'pending',
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
      await batch.commit();

      return Right(model.copyWith(refundTicketIds: refundTicketIds));
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'requestEventCancellation',
      );
    }
  }

  @override
  Future<Either<Failure, List<EventCancellationRequestEntity>>>
  getPendingRequests() async {
    try {
      final snapshot = await _requests
          .where('status', isEqualTo: EventCancellationStatus.pending.name)
          .orderBy('requestedAt', descending: true)
          .get();
      return Right(
        snapshot.docs.map(EventCancellationRequestModel.fromSnapshot).toList(),
      );
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'getPendingEventCancellationRequests',
      );
    }
  }

  @override
  Future<Either<Failure, EventCancellationRequestEntity>> reviewCancellation({
    required EventCancellationRequestEntity request,
    required bool approve,
    required String reviewerId,
  }) async {
    try {
      final reviewedRequest = request.copyWith(
        status: approve
            ? EventCancellationStatus.approved
            : EventCancellationStatus.rejected,
        reviewedAt: DateTime.now(),
        reviewerId: reviewerId,
      );
      await _requests
          .doc(request.id)
          .update(
            EventCancellationRequestModel(
              id: reviewedRequest.id,
              eventId: reviewedRequest.eventId,
              eventTitle: reviewedRequest.eventTitle,
              requesterId: reviewedRequest.requesterId,
              creatorId: reviewedRequest.creatorId,
              reason: reviewedRequest.reason,
              details: reviewedRequest.details,
              requestedAt: reviewedRequest.requestedAt,
              status: reviewedRequest.status,
              reviewedAt: reviewedRequest.reviewedAt,
              reviewerId: reviewedRequest.reviewerId,
              refundRequired: reviewedRequest.refundRequired,
              refundTicketIds: reviewedRequest.refundTicketIds,
            ).toMap(),
          );
      return Right(reviewedRequest);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'reviewEventCancellation',
      );
    }
  }
}
