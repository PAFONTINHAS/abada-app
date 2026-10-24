import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/core/utils/list_converter.dart';
import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/data/models/event_product_item_model.dart';

class EventEntityModel extends EventEntity{

  const EventEntityModel({
    required super.city,
    required super.state,
    required super.eventId,
    required super.products,
    required super.eventName,
    required super.eventType,
    required super.eventValue,
    required super.eventActive,
    required super.eventInitDate,
    required super.eventLocation,
    required super.finishedEvent,
    required super.eventCreatorId,
    required super.eventEndingDate,
    required super.eventDescription,
    required super.eventCreatorNickname,

    super.eventImagePath,
    super.selectedClassId,
    super.selectedMembersId,
  });

  factory EventEntityModel.fromSnapshot(DocumentSnapshot snapshot){

    final data = snapshot.data() as Map<String, dynamic>;

    final initDate = DateController.toDate(data['eventInitDate']);
    final endingDate = DateController.toDate(data['eventEndingDate']);

    EventType eventType = EventTypeExtension.fromString(data['eventType']);

    final products = ListConverter.fromDynamicList(
      data['products'],
      (map) => EventProductItemModel.fromSnapshot(map)
    );

    
    return EventEntityModel(
      eventId: snapshot.id,
      products: products,
      eventType: eventType,
      city: data['city'] ?? "",
      state: data['state'] ?? "",
      eventName: data['eventName'],
      eventValue: data['eventValue'],
      eventActive: data['eventActive'],
      finishedEvent: data['finishedEvent'],
      eventLocation: data['eventLocation'],
      eventImagePath: data['eventImagePath'],
      eventCreatorId: data['eventCreatorId'],
      selectedClassId: data['selectedClassId'],
      eventInitDate: initDate ?? DateTime.now(),
      eventDescription: data['eventDescription'],
      eventEndingDate: endingDate ?? DateTime.now(),
      eventCreatorNickname: data['eventCreatorNickname'],
      selectedMembersId: Set<String>.from(data['selectedMembersId']),
    );
  }


  factory EventEntityModel.fromEntity(EventEntity entity){
    return EventEntityModel(
      city: entity.city,
      state: entity.state,
      eventId: entity.eventId,
      products: entity.products,
      eventName: entity.eventName,
      eventType: entity.eventType,
      eventValue: entity.eventValue,
      eventActive: entity.eventActive,
      finishedEvent: entity.finishedEvent,
      eventInitDate: entity.eventInitDate,
      eventLocation: entity.eventLocation,
      eventImagePath: entity.eventImagePath,
      eventCreatorId: entity.eventCreatorId,
      eventEndingDate: entity.eventEndingDate,
      selectedClassId:  entity.selectedClassId,
      eventDescription: entity.eventDescription,
      selectedMembersId: entity.selectedMembersId ,
      eventCreatorNickname: entity.eventCreatorNickname,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'state': state,
      'eventName': eventName,
      'eventValue': eventValue,
      'eventActive': eventActive,
      'eventType': eventType.name,
      'finishedEvent': finishedEvent,
      'eventInitDate': eventInitDate,
      'eventLocation': eventLocation,
      'eventCreatorId': eventCreatorId,
      'eventImagePath': eventImagePath,
      'eventEndingDate': eventEndingDate,
      'selectedClassId': selectedClassId,
      'eventDescription': eventDescription,
      'selectedMembersId': selectedMembersId,
      'eventCreatorNickname': eventCreatorNickname,
      'products': products.map((product) => product.toMap()).toList(),
    };
  }
  
}