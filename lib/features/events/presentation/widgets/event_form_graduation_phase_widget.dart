import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/member_graduation_tile.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_controller.dart';

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
        _buildSectionCard(
          title: "Turma do Evento",
          icon: Icons.groups_outlined,
          children: [
            DropdownButtonFormField<ClassEntity>(
              value: selectedClass,
              isExpanded: true,
              hint: const Text(
                "Selecione a turma para graduação",
                style: TextStyle(
                  color: ColorConstants.textSecondary,
                  fontSize: 14,
                ),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: ColorConstants.indigoColor,
              ),
              dropdownColor: ColorConstants.surfaceColor,
              style: const TextStyle(
                color: ColorConstants.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: "Turma *",
                labelStyle: const TextStyle(
                  color: ColorConstants.textSecondary,
                  fontSize: 14,
                ),
                floatingLabelStyle: const TextStyle(
                  color: ColorConstants.indigoColor,
                  fontWeight: FontWeight.bold,
                ),
                filled: true,
                fillColor: ColorConstants.backgroundColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: ColorConstants.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: ColorConstants.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: ColorConstants.indigoColor,
                    width: 1.5,
                  ),
                ),
              ),
              items: classes.map((classEntity) {
                return DropdownMenuItem<ClassEntity>(
                  value: classEntity,
                  child: Text(
                    classEntity.unitName,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (classEntity) {
                formController.selectClass(classEntity);
              },
            ),
          ],
        ),

        // Cartão 2: Seleção dos Alunos
        if (selectedClass != null) ...[
          const SizedBox(height: 16),
          _buildSectionCard(
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
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
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

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    Widget? action,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConstants.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorConstants.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: ColorConstants.indigoColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.textPrimary,
                  ),
                ),
              ),
              if (action != null) ...[
                const SizedBox(width: 4),
                Flexible(child: action),
              ],
            ],
          ),
          const Divider(height: 24, color: ColorConstants.borderColor),
          ...children,
        ],
      ),
    );
  }
}