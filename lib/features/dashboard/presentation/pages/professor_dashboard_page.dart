import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/core/services/logging_service.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/shared/section_widgets/section_title_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/dashboard_app_bar_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/irregular_tusca_badge_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/view_more_requests_button_widget.dart';
import 'package:sistema_abada_capoeira/features/member_validation/presentation/widgets/membership_request_item_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/dashboard_local_summary_card_list_widget.dart';
import 'package:sistema_abada_capoeira/features/member_validation/presentation/controllers/membership_validation_controller.dart';
import 'package:sistema_abada_capoeira/features/member_validation/presentation/widgets/membership_requests_empty_state_widget.dart';

class ProfessorDashboardPage extends StatelessWidget {
  const ProfessorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final membershipController = context.read<MembershipValidationController>();
    final profileController = context.read<ProfileController>();

    final memberEntryRequests = membershipController.requests;


    final memberEntryRequestsQuantity = memberEntryRequests.length;

    final userId = profileController.userProfile.uid;

    return Scaffold(
      appBar: DashboardAppBarWidget(onNotificationTap: () {}),
      body: StandardScaffoldBodyWidget(
        child: Column(
          children: [
            SectionTitleWidget(sectionTitle: "Resumo"),

            const DashboardLocalMetricSummaryCardListWidget(),

            SectionTitleWidget(sectionTitle: "Selo TUSCA"),
            const IrregularTuscaBadgeWidget(),

            SectionTitleWidget(
              sectionTitle: "Solicitações de entrada na turma",
              itemsQuantity: memberEntryRequestsQuantity,
              onPressed: (){},
            ),

            Container(
              clipBehavior: Clip.antiAlias,
              height: 250,
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

              child: memberEntryRequests.isEmpty
              ? const MembershipRequestsEmptyStateWidget()
              : ListView.builder(
                  itemCount: memberEntryRequests.length,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context, index) {
                    
                    if (index > 2) return const SizedBox.shrink();

                    final request = memberEntryRequests[index];

                    if(index == memberEntryRequestsQuantity - 1){
                      return Column(
                        children: [
                          MembershipRequestItemWidget(
                            request: request,
                            professorId: userId,
                          ),
                          ViewMoreRequestsButtonWidget(
                            onPressed: () => RouteController.redirectoToClassesEntryRequestsPage(context: context),
                          ),
                        ],
                      );
                    }

                    return MembershipRequestItemWidget(request: request, professorId: userId);
                  },
                ),
            ),

          ],
        ),
      ),
    );
  }
}
