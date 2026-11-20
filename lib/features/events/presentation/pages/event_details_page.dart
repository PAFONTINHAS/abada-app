import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_type.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_page_widgets/revision_phase_info_row_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/section_detail_card_widget.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_details_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_details_page_widgets/event_details_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_details_page_widgets/event_bottom_navigation_bar_widget.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({
    super.key,
    this.event,
    this.eventId,
    this.request,
    this.analyseEventDetails = false,
    this.isSubscriptionAllowed = false,
    required this.isProfessorActionsAllowed,
  });

  final String? eventId;
  final EventEntity? event;
  final bool analyseEventDetails;
  final bool isSubscriptionAllowed;
  final EventRequestEntity? request;
  final bool isProfessorActionsAllowed;

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
          requestId: widget.analyseEventDetails ? widget.request?.requestId : null,
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

    final isCancelationRequest = widget.request != null && widget.request!.requestType.isCancelationRequest;

    final cancelationData = isCancelationRequest ? widget.request!.eventCancelationAditionalDataEntity : null;

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
            actions: [
              
              if(!widget.analyseEventDetails && !widget.isSubscriptionAllowed && widget.isProfessorActionsAllowed)
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () => RouteController.redirectoToEventCancellationPage(
                      context: context,
                      event: controller.eventEntity!,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      foregroundColor: ColorConstants.whiteColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Cancelar Evento",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              
            ],
          ),
          body: StandardScaffoldBodyWidget(
            child: () {
              if (_initialized && controller.errorMessage != null) {
                return Center(child: Text(controller.errorMessage!));
              }
              if (!_initialized || controller.isLoading || eventEntity == null) {
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
                child: Column(
                  children: [

                  if(isCancelationRequest && cancelationData != null)
                    SectionDetailCardWidget(
                      title: "Detalhes da Solicitação",
                      icon: Icons.cancel,
                      children: [
                        RevisionPhaseInfoRowWidget(
                          label: "Motivo de Cancelamento",
                          value: cancelationData.reason,
                        ),

                        if(cancelationData.details.isNotEmpty)
                          RevisionPhaseInfoRowWidget(
                            label: "Detalhes",
                            value: cancelationData.details,
                          ),
                      ],
                    ),

                    SizedBox(height: 10),

                    EventDetailsWidget(
                      eventEntity: eventEntity,
                      eventValue: eventValue,
                      initDate: initDateStr,
                      endingDate: endDateStr,
                    ),
                  ],
                ),  
              );
            }(),
          ),

          // --- BottomNavigationBar para as ações do Coordenador ---
          bottomNavigationBar: EventBottomNavigationBarWidget(
            controller: controller,
            eventEntity: eventEntity,
            request: widget.request,
            analyseEventDetails: widget.analyseEventDetails,
            isSubscriptionAllowed: widget.isSubscriptionAllowed,
            isProfessorActionsAllowed: widget.isProfessorActionsAllowed,
          )
        );
      },
    );
  }
}
