import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/section_detail_card_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_details_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/revision_phase_info_row_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/revision_phase_financial_summary_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/revision_phase_aditional_products_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/revision_phase_general_event_info_widget.dart';

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

  // --- Diálogos de Ação para o Coordenador ---

  Future<void> _showConfirmApproveDialog(EventDetailsController controller) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ColorConstants.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Aprovar Evento",
          style: TextStyle(fontWeight: FontWeight.bold, color: ColorConstants.textPrimary),
        ),
        content: const Text(
          "Tem certeza de que deseja aprovar a publicação deste evento?",
          style: TextStyle(color: ColorConstants.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              // TODO: Chamar método de aprovação no controller
              // await controller.approveEvent();
              if (mounted) Navigator.pop(context);
            },
            child: const Text("Confirmar Aprovação"),
          ),
        ],
      ),
    );
  }

  Future<void> _showReasonModal({
    required String title,
    required String labelText,
    required Color buttonColor,
    required Function(String reason) onSubmit,
  }) async {
    _reasonController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorConstants.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorConstants.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: labelText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: ColorConstants.borderColor),
                ),
                filled: true,
                fillColor: ColorConstants.backgroundColor,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: ColorConstants.whiteColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  final reason = _reasonController.text.trim();
                  if (reason.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Por favor, preencha a justificativa.")),
                    );
                    return;
                  }
                  Navigator.pop(ctx);
                  onSubmit(reason);
                },
                child: const Text("Confirmar e Enviar", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventDetailsController>(
      builder: (context, controller, child) {
        final eventEntity = controller.eventEntity;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.analyseEventDetails ? "Análise de Evento" : "Detalhes do Evento",
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Resumo Financeiro Destacado
                    RevisionPhaseFinancialSummaryWidget(
                      totalEventValue: eventEntity.eventValue,
                    ),

                    const SizedBox(height: 16),

                    // 2. Informações Gerais do Evento
                    RevisionPhaseGeneralEventInfoWidget(
                      eventName: eventEntity.eventName,
                      eventDescription: eventEntity.eventDescription != null &&
                              eventEntity.eventDescription!.isNotEmpty
                          ? eventEntity.eventDescription!
                          : "Sem descrição informada",
                      eventType: EventTypeExtension.convertToUIText(
                        eventEntity.eventType,
                      ),
                      eventCreatorNickname: eventEntity.eventCreatorNickname,
                    ),

                    const SizedBox(height: 16),

                    // 3. Data e Localização
                    SectionDetailCardWidget(
                      title: "Data e Local",
                      icon: Icons.location_on_outlined,
                      children: [
                        RevisionPhaseInfoRowWidget(
                          label: "Localização",
                          value: eventEntity.eventLocation,
                        ),
                        RevisionPhaseInfoRowWidget(
                          label: "Período",
                          value: "$initDateStr até $endDateStr",
                        ),
                      ],
                    ),

                    // 4. Seção de Graduação (se aplicável)
                    if (eventEntity.eventType.isGraduationEvent) ...[
                      const SizedBox(height: 16),
                      SectionDetailCardWidget(
                        title: "Dados da Graduação",
                        icon: Icons.workspace_premium_outlined,
                        children: [
                          RevisionPhaseInfoRowWidget(
                            label: "Turma Selecionada",
                            value: eventEntity.selectedClassId ?? "Não informada",
                          ),
                          RevisionPhaseInfoRowWidget(
                            label: "Alunos Subindo de Corda",
                            value:
                                "${eventEntity.selectedMembersId?.length ?? 0} aluno(s)",
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 16),

                    // 5. Produtos Adicionais
                    RevisionPhaseAditionalProductsWidget(
                      eventValue: eventValue,
                      products: eventEntity.products,
                    ),

                    // 6. Imagem de Capa do Evento
                    if (eventEntity.eventImagePath != null) ...[
                      const SizedBox(height: 16),
                      SectionDetailCardWidget(
                        title: "Imagem de Capa",
                        icon: Icons.image_outlined,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: eventEntity.eventImagePath!,
                              progressIndicatorBuilder: (context, url, progress) =>
                                  const CircularProgressIndicator(),
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            }(),
          ),

          // --- BottomNavigationBar para as ações do Coordenador ---
          bottomNavigationBar: widget.analyseEventDetails && !controller.isLoading && eventEntity != null
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: ColorConstants.surfaceColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        // Botão Rejeitar
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _showReasonModal(
                              title: "Recusar Solicitação",
                              labelText: "Escreva o motivo da recusa...",
                              buttonColor: Colors.red.shade700,
                              onSubmit: (reason) async {
                                // TODO: controller.rejectEvent(reason);
                                if (mounted) Navigator.pop(context);
                              },
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red.shade700,
                              side: BorderSide(color: Colors.red.shade400),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Recusar", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Botão Pedir Alterações
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _showReasonModal(
                              title: "Solicitar Ajustes",
                              labelText: "Descreva as alterações necessárias...",
                              buttonColor: Colors.orange.shade800,
                              onSubmit: (reason) async {
                                // TODO: controller.requestChanges(reason);
                                if (mounted) Navigator.pop(context);
                              },
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.orange.shade800,
                              side: BorderSide(color: Colors.orange.shade400),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Ajustes", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Botão Aprovar
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _showConfirmApproveDialog(controller),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade700,
                              foregroundColor: ColorConstants.whiteColor,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Aprovar", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}