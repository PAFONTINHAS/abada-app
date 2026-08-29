import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/models/request_type.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/dahsboard_section_title_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/dashboard_app_bar_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/event_request_card_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/irregular_tusca_badge_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/member_entry_request_card_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/rapid_metrics_chart_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/regional_metric_summary_card_list_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/regular_tusca_badge_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/view_more_requests_button_widget.dart';

class CoordenatorDashboardPage extends StatelessWidget {
  const CoordenatorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DashboardAppBarWidget(
        name: "Pedro Silva",
        roleOrGraduation: "Coordenador • Corda Marrom",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [

                DahsboardSectionTitleWidget(sectionTitle: "Resumo da região"),

                const RegionalMetricSummaryCardListWidget(),

                DahsboardSectionTitleWidget(sectionTitle: "Métricas Rápidas"),

                const RapidMetricsChartWidget(),

                DahsboardSectionTitleWidget(sectionTitle: "Selo TUSCA"),

                const IrregularTuscaBadgeWidget(),
                

                DahsboardSectionTitleWidget(
                  sectionTitle: "Solicitações de evento",
                  itemsQuantity: 3,
                ),

                const EventRequestCardWidget(requestType: RequestType.event, eventName: 'Batizado e Troca de Cordas 2026'),
                const EventRequestCardWidget(requestType: RequestType.cancellation, eventName: 'Workshop Mestre Bandeira'),
                const EventRequestCardWidget(requestType: RequestType.dateChange, eventName: 'Workshop de Maculelê'),
                
                SizedBox(height: 15),

                const ViewMoreRequestsButtonWidget(),

                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
