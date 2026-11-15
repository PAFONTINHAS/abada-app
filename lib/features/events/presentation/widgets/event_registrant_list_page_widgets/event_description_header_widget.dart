import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';

class EventDescriptionHeaderWidget extends StatelessWidget {
  const EventDescriptionHeaderWidget({super.key, required this.event});

  final EventEntity event;

  @override
  Widget build(BuildContext context) {
    final eventDate = DateController.formatEventDate(
      event.eventInitDate,
      event.eventEndingDate,
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.eventName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorConstants.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 16,
                color: ColorConstants.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                eventDate,
                style: const TextStyle(
                  fontSize: 14,
                  color: ColorConstants.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 16,
                color: ColorConstants.textSecondary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  event.eventLocation,
                  style: const TextStyle(
                    fontSize: 14,
                    color: ColorConstants.textSecondary,
                  ),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
