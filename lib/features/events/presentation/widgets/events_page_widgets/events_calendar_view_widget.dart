import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/events_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_card_widget.dart';

class EventsCalendarViewWidget extends StatelessWidget {
  const EventsCalendarViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<EventsController, List<EventEntity>>(
      selector: (_, controller) => controller.filteredEvents,
      builder: (context, value, child) {
        final controller = context.read<EventsController>();

        final String selectedRegion = controller.selectedRegion;
        final events = controller.filteredEvents;

        if (events.isEmpty) {
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
                  "Nenhum evento encontrado em $selectedRegion",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.textPrimary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          itemCount: events.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final event = events[index];
            return EventCardWidget(
              event: event,
              onTap: () => RouteController.redirectToEventDetailsPage(
                context: context,
                eventEntity: event,
              ),
            );
          },
        );
      },
    );
  }
}
