import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/graduation_phase_class_selection_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/member_graduation_tile.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/section_detail_card_widget.dart';

class EventFormGraduationPhaseWidget extends StatelessWidget {
  const EventFormGraduationPhaseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final formController = context.watch<EventFormController>();
    final classController = context.watch<ClassController>();

    final classes = classController.lecturedClasses;
    final selectedClass = formController.selectedClass;
    final selectedIds = formController.selectedMemberIds;

    final bool allSelected = selectedClass != null &&
        selectedClass.members.isNotEmpty &&
        selectedIds.length == selectedClass.members.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cartão 1: Seleção de Turma
        SectionDetailCardWidget(
          title: "Turma do Evento",
          icon: Icons.groups_outlined,
          children: [

            GraduationPhaseClassSelectionWidget(
              selectedClass: selectedClass,
              classes: classes,
            )
          ],
        ),

        // Cartão 2: Seleção dos Alunos
        if (selectedClass != null) ...[
          const SizedBox(height: 16),
          SectionDetailCardWidget(
            title: "Alunos para Graduação",
            icon: Icons.workspace_premium_outlined,
            action: TextButton.icon(
              onPressed: () => formController.toggleSelectAllMembers(),
              style: TextButton.styleFrom(
                foregroundColor: ColorConstants.indigoColor,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: Icon(
                allSelected
                    ? Icons.deselect_rounded
                    : Icons.select_all_rounded,
                size: 16,
              ),
              label: Text(
                allSelected ? "Desmarcar todos" : "Selecionar todos",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            children: [
              if (selectedClass.members.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Column(
                    children: const [
                      Icon(
                        Icons.person_off_outlined,
                        size: 32,
                        color: ColorConstants.textSecondary,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Nenhum aluno encontrado nesta turma.",
                        style: TextStyle(
                          color: ColorConstants.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: selectedClass.members.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final member = selectedClass.members[index];
                    final isSelected = selectedIds.contains(member.studentId);

                    return MemberGraduationTileWidget(
                      member: member,
                      isSelected: isSelected,
                      onChanged: () =>
                          formController.toggleMemberSelection(member.studentId),
                    );
                  },
                ),
            ],
          ),
        ],
      ],
    );
  }

}