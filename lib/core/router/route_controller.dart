import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';

class RouteController {
  RouteController._();

  static void redirectToDashboardPage({required BuildContext context}) {
    context.go("/dashboard");
  }

  static void redirectToStudentClassPage({
    required BuildContext context,
    required ClassEntity classEntity,
  }) {
    context.go("/classes/class", extra: classEntity);
  }

  static void redirectoToClassesEntryRequestsPage({
    required BuildContext context,
  }) {
    context.push("classes/entry_requests");
  }

  static void redirectToProfilePage({required BuildContext context}) {
    context.go('/profile');
  }

  static void redirectToCreateClassPage({required BuildContext context}) {
    context.push('/classes/create');
  }

  static void redirectToEditClassPage({
    required BuildContext context,
    required ClassEntity classEntity,
  }) {
    context.push('/classes/edit', extra: classEntity);
  }

  static void pushReplacementClassPage({
    required BuildContext context,
    required ClassEntity classEntity,
  }) {
    context.pushReplacement('/classes/class', extra: classEntity);
  }

  static void redirectToMigrateClassPage({
    required BuildContext context,
    required ClassEntity classEntity,
  }) {
    context.push('/classes/migrate', extra: classEntity);
  }

  static void redirectToCreateEventPage({required BuildContext context}) {
    context.push('/events/create');
  }

  static Future<bool?> redirectToEditEventRequestPage({
    required BuildContext context,
    required EventEntity event,
    required EventRequestEntity request,
  }) {
    return context.push<bool>(
      '/events/create',
      extra: {
        'eventEntity': event,
        'requestId': request.requestId,
        'requestStatus': request.status,
        'changeReason': request.changeReason,
      },
    );
  }

  static void redirectToCreatedEventsPage({required BuildContext context}) {
    context.push('/events/created_events');
  }

  static void redirectToEventDetailsPage({
    required BuildContext context,
    String? eventId,
    String? requestId,
    EventEntity? eventEntity,
    bool analyseEventDetails = false,
  }) {
    context.push(
      '/events/event_details',
      extra: {
        'eventId': eventId,
        'requestId': requestId,
        'eventEntity': eventEntity,
        'analyseEventDetails': analyseEventDetails,
      },
    );
  }

  static void redirectToPendingEventDetailsPage({
    required BuildContext context,
  }) {
    context.push('/events/event_requests');
  }
}
