import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';

class UserEventsEntity {
  UserEventsEntity({
    required this.eventRequests,
    required this.events,
  });

  final List<EventRequestEntity> eventRequests;
  final List<EventEntity> events;
}