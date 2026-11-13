import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/utils/message_handler.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/shared/section_widgets/section_title_widget.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_controller.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/class_members_list_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/student_page_button_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/student_page_belt_info_card_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/student_page_class_info_card_widget.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_member_entity.dart';

class StudentClassPage extends StatelessWidget {
  const StudentClassPage({super.key, this.selectedClass});

  final ClassEntity? selectedClass;

  @override
  Widget build(BuildContext context) {
    final profileController = context.read<ProfileController>();
    final classController = context.read<ClassController>();
    final userProfile = profileController.userProfile;

    final ClassEntity initialClass =
        selectedClass ?? classController.attendedClasses.first;

    final userIsProfessor =
        userProfile.uid == initialClass.professor.professorId;

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
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return Column(
                children: [
                  CircularProgressIndicator(),

                  Text("Carregando os dados da sua turma..."),
                ],
              );
            }

            final classEntity =
                [
                  ...controller.lecturedClasses,
                  ...controller.attendedClasses,
                ].cast<ClassEntity?>().firstWhere(
                  (item) => item!.classId == initialClass.classId,
                  orElse: () => initialClass,
                )!;

            Future<void> removeStudent(ClassMemberEntity student) async {
              final shouldRemove = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Remover aluno?'),
                  content: Text(
                    'O aluno ${student.name ?? "selecionado"} será removido desta turma.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: const Text('Cancelar'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: const Text('Remover'),
                    ),
                  ],
                ),
              );

              if (shouldRemove != true || !context.mounted) return;

              final success = await controller.removeStudentFromClass(
                studentId: student.studentId,
                classId: classEntity.classId,
              );

              if (!context.mounted) return;
              if (success) {
                MessageHandler.showSuccess(context, 'Aluno removido da turma.');
              } else {
                MessageHandler.showError(
                  context,
                  controller.errorMessage ??
                      'Não foi possível remover o aluno.',
                );
              }
            }

            return Column(
              children: [
                StudentPageClassInfoCardWidget(classEntity: classEntity),

                if (!userIsProfessor) ...[
                  const SizedBox(height: 12),
                  StudentPageBeltInfoCardWidget(
                    currentBelt: userProfile.currentBelt,
                  ),
                ],

                const SizedBox(height: 24),

                const SectionTitleWidget(sectionTitle: "Alunos"),
                const SizedBox(height: 8),

                // O Container agora estica para caber todos os alunos
                ClassMembersListWidget(
                  studentsList: classEntity.members,
                  onRemoveStudent: userIsProfessor ? removeStudent : null,
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
                    onPressed: () => RouteController.redirectToMigrateClassPage(
                      context: context,
                      classEntity: classEntity,
                    ),
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
      ),
    );
  }
}
