import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_card_widget.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_subscription_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/events_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_subscription_controller.dart';

class EventsCalendarViewWidget extends StatelessWidget {
  const EventsCalendarViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ProfileController>();

    final user = controller.userProfile;

    return Selector<EventsController, List<EventEntity>>(
      selector: (_, controller) => controller.filteredEvents,
      builder: (context, value, child) {
        final controller = context.read<EventsController>();
        final events = controller.filteredEvents;

        if (events.isEmpty) {
          return Selector<EventsController, String>(
            selector: (_, controller) => controller.selectedRegion,
            builder: (context, selectedRegion, child) {
              final String regionInformativeText = selectedRegion == "Todas"
                  ? "Nenhum evento encontrado em Todas"
                  : "Nenhum evento encontrado no $selectedRegion";

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.event_busy,
                      size: 48,
                      color: ColorConstants.textSecondary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      regionInformativeText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }

        return Consumer<EventSubscriptionController>(
          builder: (context, controller, child){
            
            LoggingService.displayInfo("Mudanças no controller de ingressos");
            final subscriptions = controller.subscriptions;

            return ListView.separated(
              itemCount: events.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final event = events[index];

                final EventSubscriptionEntity? subscription = subscriptions
                    .firstWhereOrNull(
                      (eventSubscription) =>
                          eventSubscription.eventId == event.eventId,
                    );

                final bool alreadySubscribedToEvent = subscription != null;

                return EventCardWidget(
                  event: event,
                  alreadySubscribed: alreadySubscribedToEvent,
                  onTap: () {

                    if (alreadySubscribedToEvent) {
                      RouteController.redirectToEventReceiptPage(
                        context: context,
                        event: event,
                        subscription: subscription,
                      );
                    } else {
                      final bool isSubscriptionAllowed =
                          user.uid != event.eventCreatorId;

                      RouteController.redirectToEventDetailsPage(
                        context: context,
                        eventEntity: event,
                        isSubscriptionAllowed: isSubscriptionAllowed,
                      );
                    }
                  },
                );
              },
            );
          }
        );
      },
    );
  }
}
