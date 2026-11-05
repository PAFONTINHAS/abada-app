import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/shared/appBar/custom_app_bar_widget.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/shared/section_widgets/section_title_widget.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_card_widget.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_subscription_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/events_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/events_empty_state_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_subscription_controller.dart';

class StudentDashboardPage extends StatelessWidget {
  const StudentDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<EventsController>();

    final profileController = context.read<ProfileController>();
    final subscriptionController = context.read<EventSubscriptionController>();
    final user = profileController.userProfile;
    final events = controller.events;

    EventSubscriptionEntity? hasAlreadySubscribed(EventEntity event) {
      final subscriptions = subscriptionController.subscriptions;

      final EventSubscriptionEntity? subscription = subscriptions
          .firstWhereOrNull(
            (eventSubscription) => eventSubscription.eventId == event.eventId,
          );

      return subscription;
    }

    return Scaffold(
      appBar: CustomAppBarWidget(pageTitle: "Início", onNotificationTap: () {}),
      body: StandardScaffoldBodyWidget(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitleWidget(
                sectionTitle: "Próximos eventos",
                onPressedTitle: "Ver todos",
                onPressed: () {},
              ),

              // Altura ajustada para comportar o Card Rico
              Consumer<EventSubscriptionController>(
                builder: (context, value, child) {
                  return SizedBox(
                    height: 400,
                    child: events.isEmpty
                        ? EventsEmptyStateWidget()
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: events.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 16),
                            itemBuilder: (context, index) {
                              final event = events[index];

                              EventSubscriptionEntity? eventSubscription =
                                  hasAlreadySubscribed(event);

                              bool alreadySubscribed = eventSubscription != null;
                              return EventCardWidget(
                                event: event,
                                width: 280,
                                alreadySubscribed: alreadySubscribed, //eventSubscription != null,
                                onTap: () {
                                  if (alreadySubscribed) {
                                    RouteController.redirectToEventReceiptPage(
                                      context: context,
                                      event: event,
                                      subscription: eventSubscription,
                                    );
                                  } else {
                                    final bool isSubscriptionAllowed =
                                        user.uid != event.eventCreatorId;

                                    RouteController.redirectToEventDetailsPage(
                                      context: context,
                                      eventEntity: event,
                                      isSubscriptionAllowed:
                                          isSubscriptionAllowed,
                                    );
                                  }
                                },
                              );
                            },
                          ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // SectionTitleWidget(
              //   sectionTitle: "Minhas Inscrições",
              //   onPressedTitle: "Ver todas",
              //   onPressed: () {},
              // ),
              // UserEventSubscriptionCardWidget(
              //   eventName: "Batizado e Troca de Crodas 2026",
              //   subscriptionConfirmed: true,
              // ),
              // UserEventSubscriptionCardWidget(
              //   eventName: "Workshop de Maculelê",
              //   subscriptionConfirmed: true,
              // ),
              // UserEventSubscriptionCardWidget(
              //   eventName: "Troca de Cordas Infantil",
              //   subscriptionConfirmed: false,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
