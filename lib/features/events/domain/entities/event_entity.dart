import 'package:sistema_abada_capoeira/features/events/domain/entities/event_products_item.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';

class EventEntity {

  const EventEntity({
    required this.city,
    required this.state,
    required this.eventId,
    required this.products,
    required this.eventName,
    required this.eventType,
    required this.eventValue,
    required this.finishedEvent,
    required this.eventInitDate,
    required this.eventLocation,
    required this.eventCreatorId,
    required this.eventEndingDate,
    required this.eventDescription,
    required this.eventCreatorNickname,

    this.eventImagePath,
    this.selectedClassId,
    this.selectedMembersId,
    this.eventActive = false,
  });

  final String city;
  final String state;
  final String eventId;
  final String eventName;
  final String eventValue;
  final String eventLocation;
  final String eventCreatorId;
  final String? eventImagePath;
  final String? selectedClassId;
  final String? eventDescription;
  final String eventCreatorNickname;

  final bool eventActive;
  final bool finishedEvent;
  final EventType eventType;
  final DateTime eventInitDate;
  final DateTime eventEndingDate;
  final Set<String>? selectedMembersId;
  final List<EventProductItem> products;


  EventEntity copyWith({
    String? city,
    String? state,
    String? eventId,
    String? eventName,
    bool? eventActive,
    String? eventValue,
    bool? finishedEvent,
    EventType? eventType,
    String? eventLocation,
    String? eventImagePath,
    String? eventCreatorId,
    String? selectedClassId,
    DateTime? eventInitDate,
    String? eventDescription,
    DateTime? eventEndingDate,
    String? eventCreatorNickname,
    Set<String>? selectedMembersId,
    List<EventProductItem>? products,
  }){

    return EventEntity(
      city:                 city                 ?? this.city,
      state:                state                ?? this.state,
      eventId:              eventId              ?? this.eventId,
      products:             products             ?? this.products,
      eventName:            eventName            ?? this.eventName,
      eventType:            eventType            ?? this.eventType,
      eventValue:           eventValue           ?? this.eventValue,
      eventActive:          eventActive          ?? this.eventActive,
      finishedEvent:        finishedEvent        ?? this.finishedEvent,
      eventInitDate:        eventInitDate        ?? this.eventInitDate,
      eventLocation:        eventLocation        ?? this.eventLocation,
      eventImagePath:       eventImagePath       ?? this.eventImagePath,
      eventCreatorId:       eventCreatorId       ?? this.eventCreatorId,
      selectedClassId:      selectedClassId      ?? this.selectedClassId,
      eventEndingDate:      eventEndingDate      ?? this.eventEndingDate,
      eventDescription:     eventDescription     ?? this.eventDescription,
      selectedMembersId:    selectedMembersId    ?? this.selectedMembersId,
      eventCreatorNickname: eventCreatorNickname ?? this.eventCreatorNickname,
      
    );
  }


  

}