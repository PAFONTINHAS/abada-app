import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_type.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/features/events/data/models/event_cancelation_aditional_data_entity_model.dart';

class EventRequestEntityModel extends EventRequestEntity {
  EventRequestEntityModel({
    super.status,
    super.decidedBy,
    super.decidedAt,
    super.updatedAt,
    super.changeReason,
    super.decidedByName,
    super.rejectionReason,
    super.eventCancelationAditionalDataEntity,

    required super.eventId,
    required super.initDate,
    required super.eventName,
    required super.requestId,
    required super.endingDate,
    required super.requestType,
    required super.requesterId,
    required super.requestedAt,
    required super.requesterNickname,
    
  });

  factory EventRequestEntityModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final updatedAt = DateController.toDate(data['updatedAt']);
    final initDate = DateController.toDate(data['initDate']) ?? DateTime.now();
    final requestType = EventRequestTypeExtension.fromString(data['requestType']);
    final endingDate = DateController.toDate(data['endingDate']) ?? DateTime.now();
    final requestedAt = DateController.toDate(data['requestedAt']) ?? DateTime.now();

    final status = GenericRequestStatusExtension.fromString(data['status']);

    final eventCancelationAditionalDataEntity = data['eventCancelationAditionalData'] != null
      ? EventCancelationAditionalDataEntityModel.fromMap(data['eventCancelationAditionalData'])
      : null;

    return EventRequestEntityModel(
      status: status,
      requestId: doc.id,
      initDate: initDate,
      updatedAt: updatedAt,
      endingDate: endingDate,
      eventId: data['eventId'],
      requestType: requestType,
      requestedAt: requestedAt,
      eventName: data['eventName'],
      requesterId: data['requesterId'],
      changeReason: data['changeReason'],
      rejectionReason: data['rejectionReason'],
      requesterNickname: data['requesterNickname'],
      eventCancelationAditionalDataEntity: eventCancelationAditionalDataEntity,
      
      decidedBy: data['decidedBy'] as String?,
      decidedByName: data['decidedByName'] as String?,
      decidedAt: DateController.toDate(data['decidedAt']),
    );
  }
}
