import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/core/utils/event_registrants_list_generator.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/general_event_subscriptions_controller.dart';

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
    

    final eventDate = DateController.formatEventDate(
      widget.event.eventInitDate,
      widget.event.eventEndingDate,
    );
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Lista de Inscritos",
          style: TextStyle(
            color: ColorConstants.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: ColorConstants.surfaceColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: ColorConstants.textPrimary),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
            tooltip: "Exportar para PDF",
            onPressed: () async {


              final controller = context.read<GeneralEventSubscriptionsController>();

              if (controller.eventSubscriptions.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Não há inscritos para exportar."),
                  ),
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


              // TODO: Implementar lógica de geração de PDF geral do evento
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. CABEÇALHO DO EVENTO ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorConstants.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event.eventName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: ColorConstants.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        eventDate,
                        style: const TextStyle(fontSize: 14, color: ColorConstants.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: ColorConstants.textSecondary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.event.eventLocation,
                          style: const TextStyle(fontSize: 14, color: ColorConstants.textSecondary),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- 2. TÍTULO DA LISTA E CONTADOR ---
            Consumer<GeneralEventSubscriptionsController>(
              builder: (context, controller, child) {
                final total = controller.eventSubscriptions.length;
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

            // --- 3. LISTA DE INSCRITOS ---
            Expanded(
              child: Consumer<GeneralEventSubscriptionsController>(
                builder: (context, controller, child) {
                  if (controller.isLoading) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: ColorConstants.indigoColor),
                          SizedBox(height: 16),
                          Text("Carregando inscrições...", style: TextStyle(color: ColorConstants.textSecondary)),
                        ],
                      ),
                    );
                  }

                  if (controller.errorMessage != null) {
                    return Center(
                      child: Text(
                        "Erro: ${controller.errorMessage}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (controller.registrantsNames.isEmpty) {
                    return const Center(
                      child: Text(
                        "Nenhuma inscrição encontrada para este evento.",
                        style: TextStyle(color: ColorConstants.textSecondary),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: controller.registrantsNames.length,
                    separatorBuilder: (context, index) => const Divider(height: 1, color: ColorConstants.borderColor),
                    itemBuilder: (context, index) {
                      final subscriptionView = controller.registrantsNames[index];
                      
                      // Identifica se é uma inscrição de menor de idade
                      final isMinor = subscriptionView.isMinor;

                      final userName = subscriptionView.userNickname != "-"
                          ? "${subscriptionView.userName} - ${subscriptionView.userNickname}"
                          : subscriptionView.userName;

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        leading: CircleAvatar(
                          backgroundColor: isMinor ? Colors.orange.shade100 : Colors.green.shade100,
                          child: Icon(
                            isMinor ? Icons.escalator_warning : Icons.person,
                            color: isMinor ? Colors.orange.shade700 : Colors.green.shade700,
                          ),
                        ),
                        title: Text(
                          userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: ColorConstants.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          "Código: ${subscriptionView.verificationCode}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: ColorConstants.textSecondary,
                            fontFamily: 'monospace',
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right, color: ColorConstants.textSecondary),
                        onTap: () => RouteController.redirectToEventReceiptPage(
                          context: context,
                          event: widget.event,
                          subscription: subscriptionView.subscription,
                          showTotalPayed: false,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}