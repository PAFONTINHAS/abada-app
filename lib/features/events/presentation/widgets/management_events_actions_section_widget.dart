import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_requests_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/action_card_button_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/acess_profile.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';

class ManagementEventsActionsSectionWidget extends StatelessWidget {
  const ManagementEventsActionsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final profileController = context.read<ProfileController>();
    final eventRequestsController = context.read<EventRequestsController>();
    final pendingEventRequestsCount = eventRequestsController.eventRequests.length;

    final userRole = profileController.userProfile.role;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ActionCardButtonWidget(
                title: "Criar Evento",
                icon: Icons.add_circle_outline,
                onTap: () => RouteController.redirectToCreateEventPage(context: context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ActionCardButtonWidget(
                title: "Seus Eventos",
                icon: Icons.event_available_outlined,
                onTap: () => RouteController.redirectToCreatedEventsPage(context: context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Botão com Badge Opcional de Solicitações Pendentes

        if(userRole.isCoordinator)
          ActionCardButtonWidget(
            title: "Solicitações de Eventos",
            icon: Icons.pending_actions_outlined,
            badgeCount: pendingEventRequestsCount,
            isFullWidth: true,
            onTap: () => RouteController.redirectToPendingEventDetailsPage(context: context),
          ),
      ],
    );
  }
}