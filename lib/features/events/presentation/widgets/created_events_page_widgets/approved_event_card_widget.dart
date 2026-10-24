import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';

class ApprovedEventCardWidget extends StatelessWidget {
  final EventEntity event;
  final VoidCallback onViewEventDetails;

  const ApprovedEventCardWidget({
    super.key,
    required this.event,
    required this.onViewEventDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorConstants.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  event.eventName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.green.shade700.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  "Aprovado",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 14, color: ColorConstants.textSecondary),
              const SizedBox(width: 6),
              Text(
                "${event.eventInitDate.day}/${event.eventInitDate.month}/${event.eventInitDate.year} - ${event.eventEndingDate.day}/${event.eventEndingDate.month}/${event.eventEndingDate.year}",
                style: const TextStyle(fontSize: 13, color: ColorConstants.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onViewEventDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.indigoColor,
                foregroundColor: ColorConstants.whiteColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Ver detalhes do evento",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}