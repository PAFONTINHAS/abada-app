import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_card_widget.dart';
import 'package:sistema_abada_capoeira/features/location/presentation/controllers/location_controller.dart';

class EventsInteractiveMapWidget extends StatelessWidget {
  final List<EventEntity> events;
  // final LatLng initialCenter;
  final double initialZoom;

  const EventsInteractiveMapWidget({
    super.key,
    required this.events,
    // Podemos iniciar centralizado no Brasil, ou na localização atual do usuário
    // this.initialCenter = const LatLng(-15.7801, -47.9292), // Brasília como default
    this.initialZoom = 4.5,
  });

  void _showEventDetailsBottomSheet(BuildContext context, EventEntity event) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Deixa transparente para vermos as bordas do Card
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          // Dá um respiro das bordas da tela e da área de navegação do celular
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(ctx).padding.bottom + 16,
          ),
          child: EventCardWidget(
            event: event,
            showEventAdress: true,
            onTap: () {
              Navigator.pop(ctx);

              // TODO: Redirecionar para a página de detalhes do evento
              RouteController.redirectToEventDetailsPage(context: context, eventId: event.eventId);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final controller = context.read<LocationController>();

    final userLocation = controller.userLocationEntity;

    LatLng initialCenter;

    final brazilCenter = LatLng(-15.7801, -47.9292);

    if(userLocation == null || userLocation.cityCenterCoordinates == null){


      initialCenter = brazilCenter; 
    } else {

      LoggingService.displayInfo("Pegando localização da cidade ${userLocation.city}");

      initialCenter = LatLng(
        userLocation.cityCenterCoordinates!.latitude,
        userLocation.cityCenterCoordinates!.longitude,
      );
    }

    LoggingService.displayInfo("Centro inicial: $initialCenter");



    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorConstants.borderColor),
      ),
      // ClipRRect garante que o mapa não "vaze" pelas bordas arredondadas do container
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: initialCenter,
            initialZoom: 11,
            // Permite que o mapa responda a gestos normais
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            // Camada de imagens do OpenStreetMap (Gratuito e sem chave de API)
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'br.ufpr.sistema_abada_capoeira', // Coloque o package name do seu app,
              tileProvider: NetworkTileProvider(),
            ),
            
            const RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contribuitors',
                  onTap: null,
                )
              ],
            ),
            
            // Camada de Marcadores (Pins dos eventos)
            MarkerLayer(
              markers: events.map((event) {
                // ATENÇÃO: Aqui assumimos que o EventEntity tem latitude e longitude!
                // Caso não tenha, o mapa não tem como saber onde colocar o Pin.
                return Marker(
                  point: LatLng(event.latitude, event.longitude), 
                  width: 50,
                  height: 50,
                  alignment: Alignment.topCenter, // Faz a "ponta" do ícone apontar para o local exato
                  child: GestureDetector(
                    onTap: () => _showEventDetailsBottomSheet(context, event),
                    child: const Icon(
                      Icons.location_on,
                      color: ColorConstants.indigoColor,
                      size: 40,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}