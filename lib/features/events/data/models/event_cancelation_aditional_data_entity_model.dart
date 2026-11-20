import 'package:sistema_abada_capoeira/features/events/domain/entities/event_cancelation_aditional_data_entity.dart';

class EventCancelationAditionalDataEntityModel extends EventCancelationAditionalDataEntity {

  EventCancelationAditionalDataEntityModel({
    required super.reason,
    required super.details,
    required super.refundRequired,
  });


  factory EventCancelationAditionalDataEntityModel.fromMap(Map<String, dynamic> data){
    return EventCancelationAditionalDataEntityModel(
      reason: data['reason'],
      details: data['details'],
      refundRequired: data['refundRequired'],
    );
  }
}