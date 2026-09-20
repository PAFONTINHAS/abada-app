import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/features/member_validation/presentation/controllers/membership_validation_controller.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/shared/section_widgets/section_title_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/class_card_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/class_entry_requests_button_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/class_local_summary_card_list_widget.dart';



class ProfessorClassesPage extends StatelessWidget {
  const ProfessorClassesPage({super.key});

  @override
  Widget build(BuildContext context) {

    final classController = context.read<ClassController>();
    final membershipController = context.read<MembershipValidationController>();

    final membershipRequests = membershipController.requests;

    final currentAttendedClass = classController.attendedClasses.first;

    final double maxListSize = 500.0;

    final double currentListSize = classController.lecturedClasses.length * 170.0;

    final double listSize = (currentListSize > maxListSize) ? maxListSize : currentListSize;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Turmas",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [

          if(membershipRequests.isNotEmpty)
            ClassEntryRequestsButtonWidget(
              onPressed: () => RouteController.redirectoToClassesEntryRequestsPage(context: context)
            ),
        ],
      ),
      body: StandardScaffoldBodyWidget(
        child: Column(
          children: [

            const ClassLocalMetricSummaryCardListWidget(),
            
            SectionTitleWidget(sectionTitle: "Turma Atual"),

            ClassCardWidget(classEntity: currentAttendedClass),

            SectionTitleWidget(sectionTitle: "Minhas Turmas", onPressed: (){}, onPressedTitle: "+ Criar Turma",),

            SizedBox(
              height: listSize,// classController.lecturedClasses.length * 170,
              child: ListView.builder(
                physics: const  ScrollPhysics(),
                itemCount: classController.lecturedClasses.length,
                itemBuilder: (context, index) {
                  final lecturedClass = classController.lecturedClasses[index];

                  return ClassCardWidget(classEntity: lecturedClass);
                },
              ),
            ),
                
          ],
        ),

      )
    );
  }
}