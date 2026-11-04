import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_card_tags_widget.dart';

class EventCardWidget extends StatelessWidget {
  final double? width;
  final EventEntity event;
  final VoidCallback onTap;
  final bool showEventAdress;
  final bool alreadySubscribed;

  const EventCardWidget({
    super.key,
    this.width,
    required this.event,
    required this.onTap,
    this.showEventAdress = false,
    this.alreadySubscribed = false,
  });

  Widget _buildFallbackImage() {
    return Container(
      height: 140,
      width: double.infinity,
      color: ColorConstants.indigoLight,
      child: Center(
        child: Image.asset('assets/images/generic_event_image.jpg')
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                EventCardTagsWidget(event: event, alreadySubscribed: alreadySubscribed),
 
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
                        DateController.formatEventDate(event.eventInitDate, event.eventEndingDate),
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
                    child: Text(
                      alreadySubscribed
                          ? "Ver comprovante"
                          : "Ver detalhes do evento", 
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