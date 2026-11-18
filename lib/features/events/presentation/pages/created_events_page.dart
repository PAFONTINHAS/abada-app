
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_policy.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_status_card_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/created_events_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/request_decision_details_dialog_widget.dart';

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
      if (profileController.status != ProfileLoadStatus.loaded) return;
      await controller.getUserEvents(profileController.userProfile.uid);
    });
  }

  void _navigateToEventDetails({
    String? eventId,
    EventEntity? eventEntity,
    bool isProfessorActionsAllowed = true
  }) {

    LoggingService.displayInfo("isProfessorActionsAllowed: $isProfessorActionsAllowed");
    RouteController.redirectToEventDetailsPage(
      context: context,
      eventId: eventId,
      eventEntity: eventEntity,
      isProfessorActionsAllowed: isProfessorActionsAllowed
    );
  }

  void _showRequestDetailsModal(EventRequestEntity request) {
    showDialog(
      context: context,
      builder: (_) => RequestDecisionDetailsDialogWidget(
        request: request,
      ),
    );
  }

  Future<void> _navigateToEditEventRequest(
    EventRequestEntity request,
  ) async {
    final controller = context.read<CreatedEventsController>();

    if (!EventRequestPolicy.canEdit(request.status) ||
        controller.isOpeningEditor) {
      return;
    }

    controller.setOpeningEditor(true);

    try {
      final result = await controller.getEventById(request.eventId);

      if (!mounted) return;

      await result.fold<Future<void>>(
        (failure) async {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Não foi possível carregar o evento: ${failure.message}',
              ),
            ),
          );
        },
        (event) async {
          final saved =
              await RouteController.redirectToEditEventRequestPage(
                context: context,
                event: event,
                request: request,
              );

          if (!mounted || saved != true) return;

          await controller.getUserEvents(
            context.read<ProfileController>().userProfile.uid,
          );
        },
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao abrir a edição do evento: $error'),
        ),
      );
    } finally {
      controller.setOpeningEditor(false);
    }
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
        iconTheme: const IconThemeData(
          color: ColorConstants.textPrimary,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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

            final approvedEvents = controller.userEvents.where((event) => !event.finishedEvent);
            final finishedEvents = controller.userEvents.where((event) => event.finishedEvent);

            // Combina ambas as listas
            final List<dynamic> allItems = [...requests, ...approvedEvents, ...finishedEvents];

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

                final isProfessorActionsAllowed = item is EventEntity;

                return EventStatusCardWidget(
                  item: item,
                  onViewEventDetails: () => _navigateToEventDetails(
                    eventId: item is EventRequestEntity ? item.eventId : null,
                    eventEntity: item is EventEntity ? item : null,
                    isProfessorActionsAllowed: isProfessorActionsAllowed,
                    
                  ),
                  onEditRequest: item is EventRequestEntity
                    ? () async {
                        await _navigateToEditEventRequest(item);
                      }
                    : null,
                  onViewRequestDetails: item is EventRequestEntity 
                      ? () => _showRequestDetailsModal( item)
                      : null,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
