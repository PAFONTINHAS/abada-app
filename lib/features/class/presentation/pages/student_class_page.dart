import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/shared/section_widgets/section_title_widget.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/class_members_list_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/student_page_button_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/student_page_belt_info_card_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/student_page_class_info_card_widget.dart';


class StudentClassPage extends StatelessWidget {
  const StudentClassPage({super.key, this.selectedClass});

  final ClassEntity? selectedClass;

  @override
  Widget build(BuildContext context) {
    
    final profileController = context.read<ProfileController>();
    final classController = context.read<ClassController>();
    final userProfile = profileController.userProfile;

    final ClassEntity classEntity = selectedClass ?? classController.attendedClasses.first;

    final userIsProfessor =
        userProfile.uid ==
        classEntity.professor.professorId;
    

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Minha Turma",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: StandardScaffoldBodyWidget(
        padding: EdgeInsets.all(16),
        child: Consumer<ClassController>(
          
          builder: (context, controller, child){

            if(controller.isLoading){

              return Column(
                children: [
                  CircularProgressIndicator(),

                  Text("Carregando os dados da sua turma...")
                ],
              );
            }

            return Column(
              children: [

                StudentPageClassInfoCardWidget(classEntity: classEntity),

                if (!userIsProfessor) ...[
                  const SizedBox(height: 12),
                  StudentPageBeltInfoCardWidget(currentBelt: userProfile.currentBelt),
                ],

                const SizedBox(height: 24),

                const SectionTitleWidget(sectionTitle: "Alunos"),
                const SizedBox(height: 8),

                // O Container agora estica para caber todos os alunos

                ClassMembersListWidget(studentsList: classEntity.members),


                if (userIsProfessor)
                  StudentPageButtonWidget(
                    icon: Icons.delete_outline,
                    buttonTitle: "Deletar turma",
                    buttonColor: Colors.red,
                    onPressed: () {},
                  )
                else ...[
                  StudentPageButtonWidget(
                    icon: Icons.cached_outlined,
                    buttonTitle: "Solicitar entrada em outra turma",
                    buttonColor: ColorConstants.indigoColor,
                    onPressed: () {},
                  ),

                  StudentPageButtonWidget(
                    icon: Icons.logout,
                    buttonTitle: "Solicitar saída da turma",
                    buttonColor: Colors.red,
                    onPressed: () {},
                  ),
                ],
              ],
            );
          },
        ), 
      ) 
    );
  }
}

