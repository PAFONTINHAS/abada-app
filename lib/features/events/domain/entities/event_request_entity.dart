import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_creation_parameters.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';

class EventRequestEntity extends GenericRequestCreationParameters {

  EventRequestEntity({
    required this.eventId,
    required super.requestId,
    required this.requesterId,
    required super.requestedAt,
    required this.endingDate,
    required this.eventName,
    required this.initDate,
    required this.requesterNickname,
    this.decidedBy,
    this.decidedByName,
    this.decidedAt,   

    super.status,
    super.updatedAt,
    super.changeReason,
    super.rejectionReason,
  });

  final String? decidedBy;
  final String? decidedByName;
  final DateTime? decidedAt;
  final String requesterId;
  final String requesterNickname;
  final String eventId;
  final String eventName;
  final DateTime initDate;
  final DateTime endingDate;

  Map<String, dynamic> toMap(){

    return {
      'eventId': eventId,
      'initDate': initDate,
      'status': status.name,
      'updatedAt': updatedAt,
      'eventName': eventName,
      'endingDate': endingDate,
      'requesterId': requesterId,
      'requestedAt': requestedAt,
      'changeReason': changeReason,
      'rejectionReason': rejectionReason,
      'requesterNickname': requesterNickname,
      'decidedBy': decidedBy,
      'decidedByName': decidedByName,
      'decidedAt': decidedAt,
    };
  }

  EventRequestEntity copyWith({
    final String? requestId,
    final String? rejectionReason,
    final String? changeReason,
    final DateTime? requestedAt,
    final DateTime? updatedAt,
    final GenericRequestStatus? status,
    final String? requesterId,
    final String? requesterNickname,
    final String? eventId,
    final String? eventInitDate,
    final String? eventName,
    final DateTime? initDate,
    final DateTime? endingDate,
    String? decidedBy,
    String? decidedByName,
    DateTime? decidedAt,
  }){
    return EventRequestEntity(
      status: status ?? this.status,
      eventId: eventId ?? this.eventId,
      initDate: initDate ?? this.initDate,
      updatedAt: updatedAt ?? this.updatedAt,
      eventName: eventName ?? this.eventName,
      requestId: requestId ?? this.requestId,
      endingDate: endingDate ?? this.endingDate,
      requesterId: requesterId ?? this.requesterId,
      requestedAt: requestedAt ?? this.requestedAt,
      changeReason: changeReason ?? this.changeReason,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      requesterNickname: requesterNickname ?? this.requesterNickname,
      decidedBy: decidedBy ?? this.decidedBy,
      decidedByName: decidedByName ?? this.decidedByName,
      decidedAt: decidedAt ?? this.decidedAt,
    );
  }


}