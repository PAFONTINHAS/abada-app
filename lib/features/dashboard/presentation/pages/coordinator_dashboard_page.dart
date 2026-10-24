import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/requests/domain/entities/generic_request_status.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_request_entity.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/shared/section_widgets/section_title_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_status_card_widget.dart';
import 'package:sistema_abada_capoeira/shared/appBar/custom_app_bar_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_requests_controller.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/rapid_metrics_chart_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/view_more_requests_button_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/regional_metric_summary_card_list_widget.dart';
import 'package:sistema_abada_capoeira/features/member_validation/presentation/widgets/membership_requests_empty_state_widget.dart';

class CoordinatorDashboardPage extends StatelessWidget {
  const CoordinatorDashboardPage({super.key});

  void _showRequestDetailsModal(BuildContext context, EventRequestEntity request) {
    String title = "Detalhes da Solicitação";
    String? reason;

    if (request.status == GenericRequestStatus.changesRequested) {
      title = "Solicitação de Alterações";
      reason = request.changeReason ?? "Nenhum motivo informado.";
    } else if (request.status == GenericRequestStatus.rejected) {
      title = "Motivo da Recusa";
      reason = request.rejectionReason ?? "Nenhum motivo informado.";
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ColorConstants.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: ColorConstants.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Observação:",
              style: TextStyle(fontWeight: FontWeight.w600, color: ColorConstants.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorConstants.backgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: ColorConstants.borderColor),
              ),
              child: Text(
                reason ?? "Sem observações detalhadas.",
                style: const TextStyle(color: ColorConstants.textPrimary, fontSize: 14),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Fechar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventRequestsController = context.read<EventRequestsController>();
    
    final eventRequests = eventRequestsController.eventRequests;
    final eventRequestsQuantity = eventRequests.length;
    
    void navigateToEventDetails(String eventId) {
      RouteController.redirectToEventDetailsPage(
        context: context,
        eventId: eventId,
        analyseEventDetails: true
      );
    }

    return Scaffold(
      appBar: CustomAppBarWidget(
        pageTitle: "Início",
        onNotificationTap: (){} ,
      ),

      body: StandardScaffoldBodyWidget(
        child: Column(
          children: [
            SectionTitleWidget(sectionTitle: "Resumo da região"),
            const RegionalMetricSummaryCardListWidget(),
            
            SectionTitleWidget(sectionTitle: "Métricas Rápidas"),
            const RapidMetricsChartWidget(),
            
            SectionTitleWidget(
              sectionTitle: "Solicitações de evento",
              itemsQuantity: eventRequestsQuantity > 3 ? 3 : eventRequestsQuantity,
            ),
            
            Container(
              clipBehavior: Clip.antiAlias,
              height: 500, // Mantido como solicitado originalmente para rolagem do container
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: eventRequests.isEmpty
                  ? const MembershipRequestsEmptyStateWidget()
                  : ListView.separated(
                      itemCount: eventRequestsQuantity,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        if (index > 2) return const SizedBox.shrink();

                        final item = eventRequests[index];
                        final card = EventStatusCardWidget(
                          item: item,
                          onViewEventDetails: () => navigateToEventDetails(item.eventId),
                          onViewRequestDetails: () => _showRequestDetailsModal(context, item),
                        );

                        if (index == eventRequestsQuantity - 1 || index == 2) {
                          return Column(
                            children: [
                              card,
                              const SizedBox(height: 12),
                              if (eventRequestsQuantity > 3 || index == eventRequestsQuantity - 1)
                                ViewMoreRequestsButtonWidget(
                                  onPressed: () => RouteController.redirectToPendingEventDetailsPage(context: context),
                                ),
                            ],
                          );
                        }

                        return card;
                      },
                    ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}