import 'package:sistema_abada_capoeira/features/events/domain/entities/event_products_item.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';

class EventEntity {

  const EventEntity({
    required this.eventId,
    required this.products,
    required this.eventName,
    required this.eventType,
    required this.eventValue,
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

  final String eventId;
  final String eventName;
  final String? eventDescription;
  final String eventLocation;
  final String eventValue;
  final String eventCreatorId;
  final String eventCreatorNickname;
  final String? eventImagePath;

  final bool eventActive;
  final EventType eventType;
  final DateTime eventInitDate;
  final String? selectedClassId;
  final DateTime eventEndingDate;
  final Set<String>? selectedMembersId;
  final List<EventProductItem> products;

  EventEntity copyWith({
    String? eventId,
    String? eventName,
    String? eventImagePath,
    bool? eventActive,
    String? eventValue,
    EventType? eventType,
    String? eventLocation,
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
      eventId:              eventId              ?? this.eventId,
      products:             products             ?? this.products,
      eventName:            eventName            ?? this.eventName,
      eventType:            eventType            ?? this.eventType,
      eventValue:           eventValue           ?? this.eventValue,
      eventActive:          eventActive          ?? this.eventActive,
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