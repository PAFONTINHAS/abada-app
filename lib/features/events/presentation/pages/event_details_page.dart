import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_details_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_details_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_details_navigation_bar_widget.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({
    super.key,
    this.event,
    this.eventId,
    this.requestId,
    this.analyseEventDetails = false,
  });

  final String? eventId;
  final String? requestId;
  final EventEntity? event;
  final bool analyseEventDetails;

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  bool _initialized = false;
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = context.read<EventDetailsController>();

      if (widget.eventId != null) {
        await controller.getEventById(
          widget.eventId!,
          requestId: widget.analyseEventDetails ? widget.requestId : null,
        );
        if (mounted) setState(() => _initialized = true);
        return;
      }

      if (widget.event != null) {
        controller.setEventEntity(widget.event!);
        setState(() => _initialized = true);
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
              if (_initialized && controller.errorMessage != null) {
                return Center(child: Text(controller.errorMessage!));
              }
              if (!_initialized ||
                  controller.isLoading ||
                  eventEntity == null) {
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
          bottomNavigationBar:
              widget.analyseEventDetails &&
                  widget.requestId != null &&
                  _initialized &&
                  eventEntity != null &&
                  controller.canDecide(
                    widget.requestId!,
                    widget.eventId ?? widget.event?.eventId ?? '',
                  )
              ? EventDetailsNavigationBarWidget(
                  controller: controller,
                  requestId: widget.requestId!,
                )
              : null,
        );
      },
    );
  }
}
