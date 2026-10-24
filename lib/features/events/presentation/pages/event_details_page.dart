import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_details_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_details_page_widgets/event_details_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_details_page_widgets/event_details_navigation_bar_widget.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({
    super.key,
    this.event,
    this.eventId,
    this.analyseEventDetails = false,
  });

  final String? eventId;
  final EventEntity? event;
  final bool analyseEventDetails;

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<EventDetailsController>();

      if (widget.eventId != null) {
        controller.getEventById(widget.eventId!);
        return;
      }

      if (widget.event != null) {
        controller.setEventEntity(widget.event!);
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventDetailsController>(
      builder: (context, controller, child) {
        final eventEntity = controller.eventEntity;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.analyseEventDetails
                  ? "Análise de Evento"
                  : "Detalhes do Evento",
              style: const TextStyle(
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
          body: StandardScaffoldBodyWidget(
            child: () {
              if (controller.isLoading || eventEntity == null) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 8),
                      Text("Carregando dados do evento"),
                    ],
                  ),
                );
              }

              final String eventValue = eventEntity.eventValue.isEmpty
                  ? "GRATUITO"
                  : eventEntity.eventValue;

              final String initDateStr = DateController.formatDDMMYYYYHM(
                eventEntity.eventInitDate,
              );
              final String endDateStr = DateController.formatDDMMYYYYHM(
                eventEntity.eventEndingDate,
              );

              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: EventDetailsWidget(
                  eventEntity: eventEntity,
                  eventValue: eventValue,
                  initDate: initDateStr,
                  endingDate: endDateStr,
                ),
              );
            }(),
          ),

          // --- BottomNavigationBar para as ações do Coordenador ---

          // EAI ISA. PARA CONTINUAR A PARTE DE REJEIÇÃO DE SOLICITAÇÃO E SOLICITAÇÃO DE MUDANÇAS, SIGA ESSA WIDGET
          bottomNavigationBar:
              widget.analyseEventDetails &&
                  !controller.isLoading &&
                  eventEntity != null
              ? EventDetailsNavigationBarWidget(controller: controller)
              : null,
        );
      },
    );
  }
}
