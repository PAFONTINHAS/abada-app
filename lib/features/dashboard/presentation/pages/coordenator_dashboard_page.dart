import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/dahsboard_section_title_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/dashboard_app_bar_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/member_request_card_widget.dart';
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
                SizedBox(height: 15),

                const RegionalMetricSummaryCardListWidget(),

                SizedBox(height: 15),

                DahsboardSectionTitleWidget(sectionTitle: "Selo TUSCA"),
                SizedBox(height: 10),

                const RegularTuscaBadgeWidget(),
                
                SizedBox(height: 15),

                DahsboardSectionTitleWidget(
                  sectionTitle: "Solicitações de entrada na turma",
                  itemsQuantity: 3,
                ),

                const MemberRequestCardWidget(),
                const MemberRequestCardWidget(),
                const MemberRequestCardWidget(),

                
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
