import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/features/event/presentation/pages/event_cancellation_page.dart';
import 'package:sistema_abada_capoeira/features/event/presentation/pages/event_page.dart';
import 'package:sistema_abada_capoeira/features/event/domain/entities/event_entity.dart';

class EventRoutes {
  EventRoutes._();

  static final route = GoRoute(
    path: '/events',
    builder: (context, state) => const EventPage(),
    routes: [
      GoRoute(
        path: 'cancel',
        builder: (context, state) {
          final event = state.extra;
          if (event is! EventEntity) {
            return const Scaffold(
              body: Center(child: Text('Evento inválido para cancelamento.')),
            );
          }
          return EventCancellationPage(event: event);
        },
      ),
    ],
  );
}
