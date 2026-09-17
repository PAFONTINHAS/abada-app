import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_controller.dart';
import 'package:sistema_abada_capoeira/shared/clickable/clickable_widget.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/shared/section_widgets/section_title_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/pages/student_class_page.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/class_card_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/member_entry_request_card_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/view_more_requests_button_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/class_local_summary_card_list_widget.dart';


// TODO: LIGAR AS PÁGINAS DE ESTUDANTE AO CONTROLLER

class ProfessorClassesPage extends StatelessWidget {
  const ProfessorClassesPage({super.key});

  @override
  Widget build(BuildContext context) {

    final classController = context.read<ClassController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Turmas",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          
        ),
      ),
      floatingActionButton: ClickableWidget(padding: EdgeInsets.all(10), color: ColorConstants.indigoColor, onTap: (){}, 
      child: Padding(padding: EdgeInsets.all(10),
      child:Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add, color: ColorConstants.whiteColor, fontWeight: FontWeight.bold,),

          SizedBox(width: 2, ),

          Text('Criar Turma', style: TextStyle(color: ColorConstants.whiteColor, fontSize: 15, fontWeight: FontWeight.bold),)
        ],
      )), 
      ),
      
      body: StandardScaffoldBodyWidget(

        child: Column(
          children: [

            const ClassLocalMetricSummaryCardListWidget(),
            
            SectionTitleWidget(sectionTitle: "Turma Atual"),
            ClassCardWidget(
              className: "Turma CEU",
              location: "Rua Luiz Leão, 1 - 91287-873",
              hour: "Seg, Sex - 19:30 às 21:30\nQua - 17:30 às 19:30",
              professor: "Brasileiro",
              studentQuantity: 15,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => StudentClassPage(),
                ),
              ),
            ),

            SectionTitleWidget(sectionTitle: "Minhas Turmas"),

            ClassCardWidget(
              className: "Turma CEP",
              location: "Av. João Gualberto, 250 - Centro, Curitiba - PR, 80030-000",
              hour: "Qua - 19:30 às 21:30",
              professor: "Feijó",
              studentQuantity: 17,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => StudentClassPage(),
                ),
              ),
            ),            
            
        
          
            SectionTitleWidget(sectionTitle: "Solicitações de Entrada", itemsQuantity: 5),

            const MemberEntryRequestCardWidget(),
            const MemberEntryRequestCardWidget(),
            const MemberEntryRequestCardWidget(),

            const ViewMoreRequestsButtonWidget(),



          ],
        ),

      )
    );
  }
}