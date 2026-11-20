import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_status_card_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_requests_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/created_events_controller.dart';

class PendingEventRequestsPage extends StatefulWidget {
  const PendingEventRequestsPage({super.key});

  @override
  State<PendingEventRequestsPage> createState() => _PendingEventRequestsPageState();
}

class _PendingEventRequestsPageState extends State<PendingEventRequestsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<EventRequestsController>().getPendingRequests();
    });
  }

  void _openEvent(EventRequestEntity request) {
    RouteController.redirectToEventDetailsPage(
      context: context,
      eventId: request.eventId,
      request: request,
      analyseEventDetails: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Solicitações de Eventos",
          style: TextStyle(
            color: ColorConstants.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: ColorConstants.surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        iconTheme: const IconThemeData(color: ColorConstants.textPrimary),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),

        child: Consumer<EventRequestsController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

          if (controller.errorMessage != null) {
            return Center(child: Text(controller.errorMessage!));
          }

          if (controller.eventRequests.isEmpty) {
            return const Center(child: Text('Nenhuma solicitação pendente.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.eventRequests.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final request = controller.eventRequests[index];

                return EventStatusCardWidget(
                  item: request,
                  onViewEventDetails: () => _openEvent(request),
                  onViewRequestDetails: () => _openEvent(request),
                );
              },
            );
          },
        ),
      ),
    );
  }
}


