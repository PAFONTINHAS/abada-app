import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/dashboard_app_bar_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/member_entry_request_card_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/regular_tusca_badge_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/dahsboard_section_title_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/local_summary_card_list_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/view_more_requests_button_widget.dart';

class ProfessorDashboardPage extends StatelessWidget {
  const ProfessorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DashboardAppBarWidget(
        name: "Idalina",
        roleOrGraduation: "Professora • Corda Roxa",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [

                DahsboardSectionTitleWidget(sectionTitle: "Resumo"),

                const LocalMetricSummaryCardListWidget(),


                DahsboardSectionTitleWidget(sectionTitle: "Selo TUSCA"),
                const RegularTuscaBadgeWidget(),
                

                DahsboardSectionTitleWidget(
                  sectionTitle: "Solicitações de entrada na turma",
                  itemsQuantity: 3,
                ),

                const MemberEntryRequestCardWidget(),
                const MemberEntryRequestCardWidget(),
                const MemberEntryRequestCardWidget(),

                const ViewMoreRequestsButtonWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}