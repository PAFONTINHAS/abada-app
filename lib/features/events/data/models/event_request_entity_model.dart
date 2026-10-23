import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';

class EventRequestEntityModel extends EventRequestEntity {
  EventRequestEntityModel({
    super.changeReason,
    super.rejectionReason,
    required super.requestId,
    required super.eventId,
    required super.requesterId,
    required super.requestedAt,
    required super.requesterNickname,
    super.updatedAt,
    super.status
  });

  factory EventRequestEntityModel.fromSnapshot(DocumentSnapshot doc){

    final data = doc.data() as Map<String,dynamic>;

    final requestedAt = DateController.toDate(data['requestedAt']) ?? DateTime.now();
    final updatedAt = DateController.toDate(data['updatedAt']);

    final GenericRequestStatus status = GenericRequestStatusExtension.fromString(data['status']);

    return EventRequestEntityModel(
      status: status,
      requestId: doc.id,
      updatedAt: updatedAt,
      eventId: data['eventId'],
      requestedAt: requestedAt,
      requesterId: data['requesterId'],
      changeReason: data['changeReason'],
      rejectionReason: data['rejectionReason'],
      requesterNickname: data['requesterNickname'],
    );
  }

}