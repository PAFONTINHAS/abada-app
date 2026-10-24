import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/shared/section_widgets/section_title_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/created_events_page_widgets/request_item_card.dart';
import 'package:sistema_abada_capoeira/shared/appBar/custom_app_bar_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_requests_controller.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/rapid_metrics_chart_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/view_more_requests_button_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/regional_metric_summary_card_list_widget.dart';
import 'package:sistema_abada_capoeira/features/member_validation/presentation/widgets/membership_requests_empty_state_widget.dart';

class CoordinatorDashboardPage extends StatelessWidget {
  const CoordinatorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {

    final eventRequestsController = context.read<EventRequestsController>();
    
    final eventRequests = eventRequestsController.eventRequests;
    final eventRequestsQuantity = eventRequests.length;
    
    void navigateToEventDetails(String eventId) {

      return RouteController.redirectToEventDetailsPage(
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
              itemsQuantity: 3,
            ),

            
            Container(
              clipBehavior: Clip.antiAlias,
              height: 500,
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
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {

                        if (index > 2) return const SizedBox.shrink();

                        final item = eventRequests[index];

                        if(index == eventRequestsQuantity - 1){
                          return Column(
                            children: [
                              RequestItemCard(
                                request: item,
                                onViewEventDetails: () => navigateToEventDetails(item.eventId),
                                onViewRequestDetails: () => {}
                              ),
                              ViewMoreRequestsButtonWidget(
                                onPressed: () => RouteController.redirectToPendingEventDetailsPage(context: context),
                              ),
                            ],
                          );
                        }

                        return RequestItemCard(
                          request: item,
                          onViewEventDetails: () => navigateToEventDetails(item.eventId),
                          onViewRequestDetails: () => {}
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
