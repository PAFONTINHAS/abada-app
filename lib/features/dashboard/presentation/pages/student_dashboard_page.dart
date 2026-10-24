import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/shared/section_widgets/section_title_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_card_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/events_controller.dart';
import 'package:sistema_abada_capoeira/shared/appBar/custom_app_bar_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/user_event_subscription_card_widget.dart';

class StudentDashboardPage extends StatelessWidget {
  const StudentDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<EventsController>();
    final events = controller.events;

    return Scaffold(
      appBar: CustomAppBarWidget(
        pageTitle: "Início",
        onNotificationTap: (){} ,
      ),
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
              SizedBox(
                height: 400,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: events.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final evento = events[index];

                    return EventCardWidget(
                      event: evento,
                      width:
                          280, // Limita a largura para o carrossel horizontal
                      onTap: () {
                        LoggingService.displayInfo(
                          "Acessando evento: ${evento.eventName}",
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              SectionTitleWidget(
                sectionTitle: "Minhas Inscrições",
                onPressedTitle: "Ver todas",
                onPressed: () {},
              ),
              UserEventSubscriptionCardWidget(
                eventName: "Batizado e Troca de Crodas 2026",
                subscriptionConfirmed: true,
              ),
              UserEventSubscriptionCardWidget(
                eventName: "Workshop de Maculelê",
                subscriptionConfirmed: true,
              ),
              UserEventSubscriptionCardWidget(
                eventName: "Troca de Cordas Infantil",
                subscriptionConfirmed: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
