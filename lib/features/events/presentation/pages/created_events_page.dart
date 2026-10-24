import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/created_events_page_widgets/request_item_card.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/created_events_page_widgets/finished_event_card_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/created_events_page_widgets/approved_event_card_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/created_events_controller.dart';

class CreatedEventsPage extends StatefulWidget {
  const CreatedEventsPage({super.key});

  @override
  State<CreatedEventsPage> createState() => _CreatedEventsPageState();
}

class _CreatedEventsPageState extends State<CreatedEventsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final profileController = context.read<ProfileController>();
      final controller = context.read<CreatedEventsController>();

      final userId = profileController.userProfile.uid;
      await controller.getUserEvents(userId);
    });
  }

  void _showRequestDetailsModal(
    BuildContext context,
    EventRequestEntity request,
  ) {
    String title = "Detalhes da Solicitação";
    String? reason;

    if (request.status == GenericRequestStatus.changesRequested) {
      title = "Solicitação de Alterações";
      reason = request.changeReason;
    } else if (request.status == GenericRequestStatus.rejected) {
      title = "Motivo da Recusa";
      reason = request.rejectionReason;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ColorConstants.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: ColorConstants.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Observação dos avaliadores:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: ColorConstants.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorConstants.backgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: ColorConstants.borderColor),
              ),
              child: Text(
                reason ?? "Sem observações detalhadas.",
                style: const TextStyle(
                  color: ColorConstants.textPrimary,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Fechar"),
          ),
        ],
      ),
    );
  }

  void _navigateToEventDetails({String? eventId, EventEntity? eventEntity}) {
    return RouteController.redirectToEventDetailsPage(
      context: context,
      eventId: eventId,
      eventEntity: eventEntity,
    );

    // Implemente a navegação para a página de detalhes do evento aqui
    // Navigator.pushNamed(context, '/event-details', arguments: eventId);
  }

  @override
  Widget build(BuildContext context) {
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

            // Garante que eventRequests não traga aprovados se eles já estiverem em userEvents
            final requests = controller.eventRequests
                .where((req) => req.status != GenericRequestStatus.approved)
                .toList();

            final approvedEvents = controller.userEvents.where(
              (event) => !event.finishedEvent,
            );

            final finishedEvents = controller.userEvents.where(
              (event) => event.finishedEvent,
            );

            // Combina ambas as listas: solicitações primeiro, eventos aprovados por último
            final List<Object> allItems = [
              ...requests,
              ...approvedEvents,
              ...finishedEvents,
            ];

            if (allItems.isEmpty) {
              return const Center(
                child: Text(
                  "Nenhum evento solicitado ou publicado.",
                  style: TextStyle(color: ColorConstants.textSecondary),
                ),
              );
            }

            return ListView.separated(
              itemCount: allItems.length,
              padding: const EdgeInsets.symmetric(vertical: 16),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = allItems[index];

                if (item is EventRequestEntity) {
                  return RequestItemCard(
                    request: item,
                    onViewEventDetails: () =>
                        _navigateToEventDetails(eventId: item.eventId),
                    onViewRequestDetails: () =>
                        _showRequestDetailsModal(context, item),
                  );
                } else if (item is EventEntity) {
                  if (!item.finishedEvent) {
                    return ApprovedEventCardWidget(
                      event: item,
                      onViewEventDetails: () =>
                          _navigateToEventDetails(eventEntity: item),
                    );
                  }

                  if (item.finishedEvent) {
                    return FinishedEventCard(
                      event: item,
                      onViewEventDetails: () =>
                          _navigateToEventDetails(eventEntity: item),
                    );
                  }
                }

                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }
}
