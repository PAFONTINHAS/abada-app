import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_subscription_entity.dart';

class EventsAndUserSubscriptions {

  List<EventEntity> events;
  List<EventSubscriptionEntity> userSubscriptions;

  EventsAndUserSubscriptions({
    required this.events,
    required this.userSubscriptions
  });
}