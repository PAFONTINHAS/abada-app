import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_creation_parameters.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';

class EventRequestEntity extends GenericRequestCreationParameters {

  EventRequestEntity({
    super.changeReason,
    super.rejectionReason,
    required super.requestId,
    required this.eventId,
    required this.requesterId,
    required super.requestedAt,
    required this.requesterNickname,

    super.updatedAt,
    super.status
  });

  final String requesterId;
  final String requesterNickname;
  final String eventId;


  
  Map<String, dynamic> toMap(){

    return {
      'changeReason': changeReason,
      'requestedAt': requestedAt,
      'updatedAt': updatedAt,
      'status': status.name,
      'eventId': eventId,
      'requesterId': requesterId,
      'requesterNickname': requesterNickname,
      'rejectionReason': rejectionReason,
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
  }){
    return EventRequestEntity(
      status: status ?? this.status,
      eventId: eventId ?? this.eventId,
      updatedAt: updatedAt ?? this.updatedAt,
      requestId: requestId ?? this.requestId,
      requesterId: requesterId ?? this.requesterId,
      requestedAt: requestedAt ?? this.requestedAt,
      changeReason: changeReason ?? this.changeReason,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      requesterNickname: requesterNickname ?? this.requesterNickname,
    );
  }


}