import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/models/request_type.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/models/request_type_extension.dart';
import 'package:sistema_abada_capoeira/shared/clickable/clickable_widget.dart';

class EventRequestCardWidget extends StatelessWidget {
  const EventRequestCardWidget({
    super.key,
    required this.requestType,
    required this.eventName,
  });

  final RequestType requestType;
  final String eventName;

  @override
  Widget build(BuildContext context) {
    RequestTypeExtension.checkRequestType(requestType);

    final String requestTypeText = RequestTypeExtension.requestTypeText;
    final Color requestTypeColor = RequestTypeExtension.requestTypeColor;
    final Color requestTypeBackgroundColor = RequestTypeExtension.requestTypeBackgroundColor;

    return ClickableWidget(
      onTap: () {},
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Coluna Esquerda: Avatar e Badge de Status
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amber,
                  ),
                  child: Image.asset(
                    "assets/images/capoeira_member_profile_picture.png",
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(254, 241, 222, 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Em Análise",
                    style: TextStyle(
                      color: Color.fromRGBO(243, 136, 46, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 14),

            // Coluna Central: Informações do Evento
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    eventName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: requestTypeBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      requestTypeText,
                      style: TextStyle(
                        color: requestTypeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "26/06/2026, 10:30",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  Text(
                    "Curitiba/PR",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),

            Icon(Icons.chevron_right, size: 28, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
