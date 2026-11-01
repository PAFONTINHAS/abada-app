import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_policy.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/request_item_card.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/approved_event_card.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/finished_event_card_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/created_events_controller.dart';

class CreatedEventsPage extends StatefulWidget {
  const CreatedEventsPage({super.key});

  @override
  State<CreatedEventsPage> createState() => _CreatedEventsPageState();
}

class _CreatedEventsPageState extends State<CreatedEventsPage> {
  bool _isOpeningEditor = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final profileController = context.read<ProfileController>();
      final controller = context.read<CreatedEventsController>();

      if (profileController.status != ProfileLoadStatus.loaded) {
        return;
      }

      await controller.getUserEvents(profileController.userProfile.uid);
    });
  }

  // Exibe os detalhes da decisão sobre a solicitação.
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

    final reasonText = reason != null && reason.trim().isNotEmpty
        ? reason.trim()
        : "Sem observações detalhadas.";

    final coordinatorName =
        request.decidedByName != null &&
            request.decidedByName!.trim().isNotEmpty
        ? request.decidedByName!.trim()
        : "Não informado";

    final decisionDate = request.decidedAt;

    final formattedDecisionDate = decisionDate != null
        ? "${decisionDate.day.toString().padLeft(2, '0')}/"
              "${decisionDate.month.toString().padLeft(2, '0')}/"
              "${decisionDate.year} às "
              "${decisionDate.hour.toString().padLeft(2, '0')}:"
              "${decisionDate.minute.toString().padLeft(2, '0')}"
        : null;

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
        content: SingleChildScrollView(
          child: Column(
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
                  reasonText,
                  style: const TextStyle(
                    color: ColorConstants.textPrimary,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Responsável pela decisão:",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 18,
                    color: ColorConstants.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      coordinatorName,
                      style: const TextStyle(
                        color: ColorConstants.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              if (formattedDecisionDate != null) ...[
                const SizedBox(height: 16),
                const Text(
                  "Data da decisão:",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_outlined,
                      size: 18,
                      color: ColorConstants.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        formattedDecisionDate,
                        style: const TextStyle(
                          color: ColorConstants.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
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
    RouteController.redirectToEventDetailsPage(
      context: context,
      eventId: eventId,
      eventEntity: eventEntity,
    );
  }

  // RF22 - Busca o evento atualizado antes de abrir a edição.
  Future<void> _navigateToEditEventRequest(EventRequestEntity request) async {
    if (!EventRequestPolicy.canEdit(request.status) || _isOpeningEditor) {
      return;
    }

    setState(() {
      _isOpeningEditor = true;
    });

    try {
      final controller = context.read<CreatedEventsController>();

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
          final saved = await RouteController.redirectToEditEventRequestPage(
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
        SnackBar(content: Text('Erro ao abrir a edição do evento: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isOpeningEditor = false;
        });
      }
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
        iconTheme: const IconThemeData(color: ColorConstants.textPrimary),
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

            final requests = controller.eventRequests
                .where(
                  (request) => request.status != GenericRequestStatus.approved,
                )
                .toList();

            final approvedEvents = controller.userEvents
                .where((event) => !event.finishedEvent)
                .toList();

            final finishedEvents = controller.userEvents
                .where((event) => event.finishedEvent)
                .toList();

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
                    onEditRequest: EventRequestPolicy.canEdit(item.status)
                        ? () => _navigateToEditEventRequest(item)
                        : null,
                  );
                }

                if (item is EventEntity) {
                  if (!item.finishedEvent) {
                    return ApprovedEventCard(
                      event: item,
                      onViewEventDetails: () =>
                          _navigateToEventDetails(eventEntity: item),
                    );
                  }

                  return FinishedEventCard(
                    event: item,
                    onViewEventDetails: () =>
                        _navigateToEventDetails(eventEntity: item),
                  );
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
