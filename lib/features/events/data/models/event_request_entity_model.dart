import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';

class EventRequestEntityModel extends EventRequestEntity {
  EventRequestEntityModel({
    super.status,
    super.updatedAt,
    super.changeReason,
    super.rejectionReason,

    required super.requestId,
    required super.eventId,
    required super.requesterId,
    required super.requestedAt,
    required super.endingDate,
    required super.initDate,
    required super.eventName,
    required super.requesterNickname,
  });

  factory EventRequestEntityModel.fromSnapshot(DocumentSnapshot doc){

    final data = doc.data() as Map<String,dynamic>;

    final requestedAt = DateController.toDate(data['requestedAt']) ?? DateTime.now();
    final updatedAt = DateController.toDate(data['updatedAt']);
    final initDate = DateController.toDate(data['initDate']) ?? DateTime.now();
    final endingDate = DateController.toDate(data['endingDate']) ?? DateTime.now();


    final GenericRequestStatus status = GenericRequestStatusExtension.fromString(data['status']);

    return EventRequestEntityModel(
      status: status,
      requestId: doc.id,
      initDate: initDate,
      updatedAt: updatedAt,
      endingDate: endingDate,
      eventId: data['eventId'],
      requestedAt: requestedAt,
      eventName: data['eventName'],
      requesterId: data['requesterId'],
      changeReason: data['changeReason'],
      rejectionReason: data['rejectionReason'],
      requesterNickname: data['requesterNickname'],

    );
  }

}