import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/pages/created_events_page.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/pages/event_details_page.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/pages/event_form_page.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/pages/events_page.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/pages/pending_event_requests_page.dart';

class EventRoutes {
  EventRoutes._();

  static final route = GoRoute(
    path: '/events',
    builder: (context, state) {
      return EventsPage();
    },
    routes: [
      GoRoute(
        path: 'create',
        builder: (context, state) {
          final extra = state.extra;

          final parameters = extra is Map<String, dynamic>
              ? extra
              : <String, dynamic>{};

          final event = parameters['eventEntity'] as EventEntity?;
          final requestId = parameters['requestId'] as String?;

          return EventFormPage(
            key: ValueKey(
              event != null && requestId != null ? 'edit-$requestId' : 'create',
            ),
            eventToEdit: event,
            requestId: requestId,
            requestStatus: parameters['requestStatus'] as GenericRequestStatus?,
            changeReason: parameters['changeReason'] as String?,
          );
        },
      ),

      GoRoute(
        path: 'created_events',
        builder: (context, state) {
          return CreatedEventsPage();
        },
      ),

      GoRoute(
        path: 'event_details',
        builder: (context, state) {
          final Map<String, dynamic> parameters =
              state.extra as Map<String, dynamic>;

          final String? eventId = parameters['eventId'] as String?;
          final String? requestId = parameters['requestId'] as String?;
          final EventEntity? eventEntity =
              parameters['eventEntity'] as EventEntity?;
          final bool analyseEventDetails =
              parameters['analyseEventDetails'] as bool;

          return EventDetailsPage(
            event: eventEntity,
            eventId: eventId,
            requestId: requestId,
            analyseEventDetails: analyseEventDetails,
          );
        },
      ),

      GoRoute(
        path: 'event_requests',
        builder: (context, state) {
          return PendingEventRequestsPage();
        },
      ),
    ],
  );
}
