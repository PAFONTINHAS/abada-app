import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sistema_abada_capoeira/features/event_cancellation/presentation/controllers/event_cancellation_controller.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/tusca_badge_card_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/shared/section_widgets/section_title_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/models/request_type.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/dashboard_app_bar_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/event_request_card_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/rapid_metrics_chart_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/view_more_requests_button_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/regional_metric_summary_card_list_widget.dart';

class CoordenatorDashboardPage extends StatefulWidget {
  const CoordenatorDashboardPage({super.key});

  @override
  State<CoordenatorDashboardPage> createState() =>
      _CoordenatorDashboardPageState();
}

class _CoordenatorDashboardPageState extends State<CoordenatorDashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<EventCancellationController>().loadPendingRequests();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileController = context.read<ProfileController>();
    final userProfile = profileController.userProfile;
    final controller = context.watch<EventCancellationController>();
    final reviewerId = context.read<AuthController>().user?.uid;

    return Scaffold(
      appBar: DashboardAppBarWidget(onNotificationTap: () {}),

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

            if (controller.pendingRequests.isEmpty)
              const Text('Nenhuma solicitação pendente.')
            else
              ...controller.pendingRequests.map(
                (request) => EventRequestCardWidget(
                  requestType: RequestType.cancellation,
                  eventName: request.eventTitle.isEmpty
                      ? request.eventId
                      : request.eventTitle,
                  request: request,
                  onApprove: reviewerId == null
                      ? null
                      : () => controller.reviewCancellation(
                          request: request,
                          approve: true,
                          reviewerId: reviewerId,
                        ),
                  onReject: reviewerId == null
                      ? null
                      : () => controller.reviewCancellation(
                          request: request,
                          approve: false,
                          reviewerId: reviewerId,
                        ),
                ),
              ),

            ViewMoreRequestsButtonWidget(onPressed: () {}),

            SectionTitleWidget(sectionTitle: "Selo TUSCA"),

            TuscaBadgeCardWidget(tuscaEntity: userProfile.tusca),
          ],
        ),
      ),
    );
  }
}
