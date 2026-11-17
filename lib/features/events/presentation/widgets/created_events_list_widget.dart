
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_policy.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/created_events_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/request_item_card.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/approved_event_card.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/finished_event_card_widget.dart';

class CreatedEventsListWidget extends StatelessWidget {
  const CreatedEventsListWidget({
    super.key,
    required this.onViewEventDetails,
    required this.onViewRequestDetails,
    required this.onEditRequest,
  });

  final void Function({String? eventId, EventEntity? eventEntity})onViewEventDetails;
  final void Function(EventRequestEntity request) onViewRequestDetails;
  final void Function(EventRequestEntity request) onEditRequest;

  @override
  Widget build(BuildContext context) {
    return Consumer<CreatedEventsController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
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
            .where((request) =>request.status != GenericRequestStatus.approved,)
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
              style: TextStyle(
                color: ColorConstants.textSecondary,
              ),
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
                    onViewEventDetails(eventId: item.eventId),
                onViewRequestDetails: () =>
                    onViewRequestDetails(item),
                onEditRequest: EventRequestPolicy.canEdit(item.status)
                    ? () => onEditRequest(item)
                    : null,
              );
            }

            if (item is EventEntity) {
              if (!item.finishedEvent) {
                return ApprovedEventCard(
                  event: item,
                  onViewEventDetails: () =>
                      onViewEventDetails(eventEntity: item),
                );
              }

              return FinishedEventCard(
                event: item,
                onViewEventDetails: () =>
                    onViewEventDetails(eventEntity: item),
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
