import 'package:sistema_abada_capoeira/features/events/domain/entities/event_cancelation_aditional_data_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_type.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_creation_parameters.dart';

class EventRequestEntity extends GenericRequestCreationParameters {

  EventRequestEntity({
    this.decidedBy,
    this.decidedAt,   
    this.decidedByName,
    this.eventCancelationAditionalDataEntity,

    required this.eventId,
    required this.initDate,
    required this.eventName,
    required this.endingDate,
    required this.requestType,
    required this.requesterId,
    required this.requesterNickname,

    super.status,
    super.updatedAt,
    super.changeReason,
    super.rejectionReason,
    required super.requestId,
    required super.requestedAt,
  });

  final String eventId;
  final String eventName;
  final String? decidedBy;
  final DateTime initDate;
  final String requesterId;
  final DateTime? decidedAt;
  final DateTime endingDate;
  final String? decidedByName;
  final String requesterNickname;
  final EventRequestType requestType;
  final EventCancelationAditionalDataEntity? eventCancelationAditionalDataEntity;

  Map<String, dynamic> toMap(){

    return {
      'eventId': eventId,
      'initDate': initDate,
      'status': status.name,
      'decidedBy': decidedBy,
      'decidedAt': decidedAt,
      'updatedAt': updatedAt,
      'eventName': eventName,
      'endingDate': endingDate,
      'requesterId': requesterId,
      'requestedAt': requestedAt,
      'changeReason': changeReason,
      'decidedByName': decidedByName,
      'requestType': requestType.name,
      'rejectionReason': rejectionReason,
      'requesterNickname': requesterNickname,
      'eventCancelationAditionalData': eventCancelationAditionalDataEntity?.toMap()
    };
  }

  EventRequestEntity copyWith({
    String? requestId,
    String? eventId,
    String? decidedBy,
    String? eventName,
    DateTime? initDate,
    String? requesterId,
    DateTime? updatedAt,
    DateTime? decidedAt,
    String? changeReason,
    DateTime? endingDate,
    String? decidedByName,
    String? eventInitDate,
    DateTime? requestedAt,
    String? rejectionReason,
    String? requesterNickname,
    GenericRequestStatus? status,
    EventRequestType? requestType,
  }){
    return EventRequestEntity(
      status: status ?? this.status,
      eventId: eventId ?? this.eventId,
      initDate: initDate ?? this.initDate,
      updatedAt: updatedAt ?? this.updatedAt,
      eventName: eventName ?? this.eventName,
      decidedBy: decidedBy ?? this.decidedBy,
      requestId: requestId ?? this.requestId,
      decidedAt: decidedAt ?? this.decidedAt,
      endingDate: endingDate ?? this.endingDate,
      requestType: requestType ?? this.requestType,
      requesterId: requesterId ?? this.requesterId,
      requestedAt: requestedAt ?? this.requestedAt,
      changeReason: changeReason ?? this.changeReason,
      decidedByName: decidedByName ?? this.decidedByName,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      requesterNickname: requesterNickname ?? this.requesterNickname,
    );
  }


}