import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/utils/mask_formatter.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';

class EventCardTagsWidget extends StatelessWidget {
  const EventCardTagsWidget({
    super.key,
    required this.event,
    required this.alreadySubscribed,
  });

  final EventEntity event;
  final bool alreadySubscribed;
  @override
  Widget build(BuildContext context) {
    final bool isFree =
        event.eventValue == "0.00" ||
        event.eventValue.toLowerCase() == 'gratuito';
    final String priceText = isFree
        ? "GRATUITO"
        : MaskFormatter.convertToReais(event.eventValue);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isFree ? Colors.green.shade50 : Colors.orange.shade50,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isFree ? Colors.green.shade200 : Colors.orange.shade200,
            ),
          ),
          child: Text(
            priceText,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isFree ? Colors.green.shade700 : Colors.orange.shade800,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: ColorConstants.indigoLight,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            EventTypeExtension.convertToUIText(event.eventType),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: ColorConstants.indigoDark,
            ),
          ),
        ),
        const SizedBox(width: 8),

        if (alreadySubscribed)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Text(
              "Inscrito",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
          ),
      ],
    );
  }
}
