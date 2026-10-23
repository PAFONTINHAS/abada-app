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
  @override
  void initState() {
    // TODO: implement initState
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detalhes do Evento",
          style: TextStyle(
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
        child: Consumer<EventDetailsController>(
          builder: (context, controller, child) {
            final eventEntity = controller.eventEntity;

            if (controller.isLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CircularProgressIndicator(),

                    Text("Carregando dados do evento"),
                  ],
                ),
              );
            }

            if (eventEntity == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CircularProgressIndicator(),

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
            return Column(
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
                  eventDescription:
                      eventEntity.eventDescription != null &&
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
                            "${eventEntity.selectedMembersId?.length} aluno(s)",
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
            );
          },
        ),
      ),
    );
  }
}
