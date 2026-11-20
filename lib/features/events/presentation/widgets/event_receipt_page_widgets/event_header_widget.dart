import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';

class EventHeaderWidget extends StatelessWidget {
  const EventHeaderWidget({super.key, required this.event});

  final EventEntity event;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: ColorConstants.indigoColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
           event.eventName,
            style: const TextStyle(
              color: ColorConstants.whiteColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_month, color: Colors.white70, size: 16),
              const SizedBox(width: 8),
              Text(
                DateController.formatEventDate(
                  event.eventInitDate,
                  event.eventEndingDate,
                ),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            event.eventLocation,
            style: const TextStyle(
              color: ColorConstants.whiteColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
