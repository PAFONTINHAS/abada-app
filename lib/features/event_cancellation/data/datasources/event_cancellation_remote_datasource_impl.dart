import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:sistema_abada_capoeira/core/constants/database_constants.dart';
import 'package:sistema_abada_capoeira/core/errors/exception_handler.dart';
import 'package:sistema_abada_capoeira/core/errors/failure.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/data/datasources/event_cancellation_remote_datasource.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/data/models/event_cancellation_request_model.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/domain/entities/event_cancellation_request_entity.dart';

class EventCancellationRemoteDatasourceImpl implements EventCancellationRemoteDatasource {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Either<Failure, bool>> checkIfRequestAlreadyExists(String eventId) async{
    try{

      final query = await _firestore.collection(DBCollections.eventCancellationRequestsCollection)
      .where('eventId', isEqualTo: eventId)
      .limit(1)
      .get();

      if(query.docs.isNotEmpty) return Right(true);

      return Right(false);
    }catch(exception){

      return ExceptionHandler.handleException(exception: exception, contextMessage: "checkIfRequestAlreadyExists");
    }
  }

  @override
  Future<Either<Failure, EventCancellationRequestEntity>> requestCancellation(EventCancellationRequestEntity request) async {
    try {
      final requestReference = _firestore.collection(DBCollections.eventCancellationRequestsCollection).doc();
      final eventReference = _firestore.collection('events').doc(request.eventId);

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

      final model = EventCancellationRequestModel.fromEntity(request);

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
  Future<Either<Failure, List<EventCancellationRequestEntity>>> getPendingRequests() async {

    try {

      final requestReference = _firestore.collection(DBCollections.eventCancellationRequestsCollection);

      final snapshot = await requestReference
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

      final requestReference = _firestore.collection(DBCollections.eventCancellationRequestsCollection).doc(request.id);

      final reviewedRequest = request.copyWith(
        status: approve
            ? EventCancellationStatus.approved
            : EventCancellationStatus.rejected,
        reviewedAt: DateTime.now(),
        reviewerId: reviewerId,
      );

      final requestModel = EventCancellationRequestModel.fromEntity(request);

      await requestReference.update(requestModel.toMap());
      return Right(reviewedRequest);
    } catch (exception) {
      return ExceptionHandler.handleException(
        exception: exception,
        contextMessage: 'reviewEventCancellation',
      );
    }
  }
}
