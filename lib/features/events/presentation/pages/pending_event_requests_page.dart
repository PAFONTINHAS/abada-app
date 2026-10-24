import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/created_events_page_widgets/request_item_card.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/created_events_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_requests_controller.dart';

class PendingEventRequestsPage extends StatefulWidget {
  const PendingEventRequestsPage({super.key});

  @override
  State<PendingEventRequestsPage> createState() => _PendingEventRequestsPageState();
}

class _PendingEventRequestsPageState extends State<PendingEventRequestsPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async{
      final controller = context.read<EventRequestsController>();

      await controller.getPendingRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    void navigateToEventDetails({String? eventId, EventEntity? eventEntity}) {
      return RouteController.redirectToEventDetailsPage(
        context: context,
        eventId: eventId,
        eventEntity: eventEntity,
        analyseEventDetails: true,
      );
    }

    final eventRequestsController = context.read<EventRequestsController>();
    final eventRequests = eventRequestsController.eventRequests;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Meus Eventos",
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

        child: Consumer<CreatedEventsController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage != null) {
              return Center(
                child: Text(
                  controller.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            return ListView.separated(
              itemCount: eventRequests.length,
              padding: const EdgeInsets.symmetric(vertical: 16),
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = eventRequests[index];

                return RequestItemCard(
                  request: item,
                  onViewEventDetails: () =>
                      navigateToEventDetails(eventId: item.eventId),
                  onViewRequestDetails: () => {},
                );
              },
            );
          },
        ),
      ),
    );
  }
}

