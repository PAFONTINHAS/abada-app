import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/utils/mask_formatter.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';

class EventCardWidget extends StatelessWidget {
  final EventEntity event;
  final VoidCallback onTap;
  final double? width;
  final bool showEventAdress;

  const EventCardWidget({
    super.key,
    required this.event,
    required this.onTap,
    this.width,
    this.showEventAdress = false
  });

  String _formatEventDate(DateTime start, DateTime end) {
    final startDay = start.day.toString().padLeft(2, '0');
    final startMonth = start.month.toString().padLeft(2, '0');
    final startYear = start.year.toString();
    final startHour = start.hour.toString().padLeft(2, '0');
    final startMin = start.minute.toString().padLeft(2, '0');

    final endDay = end.day.toString().padLeft(2, '0');
    final endMonth = end.month.toString().padLeft(2, '0');
    final endYear = end.year.toString();
    final endHour = end.hour.toString().padLeft(2, '0');
    final endMin = end.minute.toString().padLeft(2, '0');

    if (startYear == endYear && startMonth == endMonth && startDay == endDay) {
      return '$startDay/$startMonth/$startYear - $startHour:$startMin até $endHour:$endMin';
    } else {
      return 'de $startDay/$startMonth/$startYear, $startHour:$startMin até $endDay/$endMonth/$endYear, $endHour:$endMin';
    }
  }

  Widget _buildFallbackImage() {
    return Container(
      height: 140,
      width: double.infinity,
      color: ColorConstants.indigoLight,
      child: const Center(
        child: Icon(Icons.event_available, size: 48, color: ColorConstants.indigoColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isFree = event.eventValue.isEmpty || event.eventValue.toLowerCase() == 'gratuito';
    final String priceText = isFree ? "GRATUITO" : MaskFormatter.convertToReais(event.eventValue);

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: ColorConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorConstants.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Imagem do Evento
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            child: event.eventImagePath != null && event.eventImagePath!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: event.eventImagePath!,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 140,
                      color: ColorConstants.backgroundColor,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => _buildFallbackImage(),
                  )
                : _buildFallbackImage(),
          ),

          // 2. Conteúdo Textual
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tags (Preço e Tipo)
                Row(
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
                  ],
                ),
                const SizedBox(height: 10),

                // Nome do Evento
                Text(
                  event.eventName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),

                // Descrição Opcional
                if (event.eventDescription != null && event.eventDescription!.isNotEmpty) ...[
                  Text(
                    event.eventDescription!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: ColorConstants.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Data e Localização
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: ColorConstants.textSecondary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: 
                        showEventAdress
                          ? Text(
                              event.eventLocation,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: ColorConstants.textSecondary,
                              ),
                            )
                          : Text(
                              "${event.city} - ${event.state}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: ColorConstants.textSecondary,
                              ),
                            )
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, size: 14, color: ColorConstants.textSecondary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _formatEventDate(event.eventInitDate, event.eventEndingDate),
                        style: const TextStyle(fontSize: 12, color: ColorConstants.textSecondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Botão de Ação
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.indigoColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Ver detalhes do evento",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}