import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/pages/created_events_page.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/pages/event_details_page.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/pages/event_form_page.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/pages/events_page.dart';

class EventRoutes {

  EventRoutes._();

  static final route = GoRoute(
    path: '/events',
    builder: (context, state){
      return EventsPage();
    },
    routes: [
      GoRoute(
        path: 'create',
        builder: (context, state){
          return EventFormPage();
        }
      ),

      GoRoute(
        path: 'created_events',
        builder: (context, state){
          return CreatedEventsPage();
        }
      ),

      GoRoute(
        path: 'event_details',
        builder: (context, state){

          final Map<String, dynamic> parameters = state.extra as Map<String, dynamic>;

          final String? eventId = parameters['eventId'] as String?;
          final EventEntity? eventEntity = parameters['eventEntity'] as EventEntity?;

          return EventDetailsPage(
            event: eventEntity,
            eventId: eventId,
          );

        }
      )
    ]
  );


}