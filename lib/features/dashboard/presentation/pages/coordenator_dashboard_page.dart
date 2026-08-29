import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/dahsboard_section_title_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/irregular_tusca_badge_widget%20copy.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/member_request_card_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/metric_summary_card_list_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/regular_tusca_badge_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/view_more_requests_button_widget.dart';

class CoordenatorDashboardPage extends StatelessWidget {
  const CoordenatorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, Professor(a) Idalina!'),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                DahsboardSectionTitleWidget(sectionTitle: "Métricas da região"),

                const MetricSummaryCardListWidget(),

                SizedBox(height: 15),

                DahsboardSectionTitleWidget(sectionTitle: "Selo TUSCA"),

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
