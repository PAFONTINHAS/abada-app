import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/utils/event_registrants_list_generator.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/general_event_subscriptions_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_registrant_list_page_widgets/subscriptions_list_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_registrant_list_page_widgets/event_description_header_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_registrant_list_page_widgets/event_registrants_appbar_widget.dart';

class EventRegistrantsListPage extends StatefulWidget {
  final EventEntity event;

  const EventRegistrantsListPage({super.key, required this.event});

  @override
  State<EventRegistrantsListPage> createState() => _EventRegistrantsListPageState();
}

class _EventRegistrantsListPageState extends State<EventRegistrantsListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Busca a lista de inscritos baseada no ID do evento
      context.read<GeneralEventSubscriptionsController>().getEventSubscriptions(widget.event.eventId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: EventRegistrantsAppbarWidget(
        onExportButtonPressed: () async {
          final controller = context .read<GeneralEventSubscriptionsController>();

          if (controller.eventSubscriptions.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Não há inscritos para exportar.")),
            );
            return;
          }

          final pdfBytes = await EventRegistrantsListGenerator.generatePdf(
            event: widget.event,
            subscriptions: controller.eventSubscriptions,
          );

          await Printing.sharePdf(
            bytes: pdfBytes,
            filename: 'lista_inscritos_${widget.event.eventId}.pdf',
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EventDescriptionHeaderWidget(event: widget.event),

            const SizedBox(height: 20),

            Consumer<GeneralEventSubscriptionsController>(
              builder: (context, controller, child) {
                final total = controller.registrantsNames.length;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                  child: Text(
                    "Participantes Inscritos ($total)",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.textPrimary,
                    ),
                  ),
                );
              },
            ),

            Expanded(child: SubscriptionsListWidget(event: widget.event)),
          ],
        ),
      ),
    );
  }
}