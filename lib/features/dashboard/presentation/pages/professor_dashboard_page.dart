import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/dashboard_app_bar_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/irregular_tusca_badge_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/member_entry_request_card_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/regular_tusca_badge_widget.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/shared/section_widgets/section_title_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/dashboard_local_summary_card_list_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/view_more_requests_button_widget.dart';

class ProfessorDashboardPage extends StatelessWidget {
  const ProfessorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DashboardAppBarWidget(
        onNotificationTap: (){} ,
      ),
      body: StandardScaffoldBodyWidget(
        child: Column(
          children: [
            SectionTitleWidget(sectionTitle: "Resumo"),

            const DashboardLocalMetricSummaryCardListWidget(),

            SectionTitleWidget(sectionTitle: "Selo TUSCA"),
            const IrregularTuscaBadgeWidget(),

            SectionTitleWidget(
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
    );
  }
}
