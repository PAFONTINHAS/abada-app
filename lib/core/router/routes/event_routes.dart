import 'package:go_router/go_router.dart';
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
      )
    ]
  );

}