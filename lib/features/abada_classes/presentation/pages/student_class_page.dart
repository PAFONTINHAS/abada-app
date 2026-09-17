import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/shared/section_widgets/section_title_widget.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/abada_classes/presentation/widgets/student_page_button_widget.dart';
import 'package:sistema_abada_capoeira/features/abada_classes/presentation/widgets/student_page_belt_info_card_widget.dart';
import 'package:sistema_abada_capoeira/features/abada_classes/presentation/widgets/student_page_class_info_card_widget.dart';

class StudentClassPage extends StatelessWidget {
  const StudentClassPage({
    super.key,
    required this.className,
    required this.hour,
    required this.location,
    required this.professor,
    required this.studentQuantity,
    this.studentsList = const [],
  });

  final String className;
  final String hour;
  final String location;
  final String professor;
  final int studentQuantity;
  final List<String> studentsList;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ProfileController>();
    final nickname = controller.userProfile.nickname;
    final bool userIsProfessor = nickname == professor;

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
        child: Column(
            children: [

              StudentPageClassInfoCardWidget(
                      className: className,
                      hour: hour,
                      location: location,
                      professor: professor,
                      studentQuantity: studentQuantity,
                    ),

                    if (!userIsProfessor) ...[
                      const SizedBox(height: 12),
                      StudentPageBeltInfoCardWidget(
                        className: className,
                        hour: hour,
                        location: location,
                        professor: professor,
                        studentQuantity: studentQuantity,
                      ),
                    ],

                    const SizedBox(height: 24),

                    const SectionTitleWidget(sectionTitle: "Alunos"),
                    const SizedBox(height: 8),

                    // O Container agora estica para caber todos os alunos
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: studentsList.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Center(
                                child: Text(
                                  "Nenhum aluno matriculado.",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 500,
                              child: ListView.separated(
                                // Estas duas linhas transferem a responsabilidade de rolar
                                // da ListView para o SingleChildScrollView pai!
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: studentsList.length,
                                separatorBuilder: (context, index) => Divider(
                                  height: 1,
                                  color: Colors.grey.shade200,
                                  indent: 72,
                                ),
                                itemBuilder: (context, index) {
                                  final aluno = studentsList[index];
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 4,
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: ColorConstants
                                          .indigoColor
                                          .withOpacity(0.1),
                                      child: const Icon(
                                        Icons.person,
                                        color: ColorConstants.indigoColor,
                                      ),
                                    ),
                                    title: Text(
                                      aluno,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Corda Crua',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.chevron_right,
                                      color: Colors.grey.shade400,
                                    ),
                                    onTap: () {},
                                  );
                                },
                              ),
                            ),
                    ),

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
          ),
      ) 
    );
  }
}
