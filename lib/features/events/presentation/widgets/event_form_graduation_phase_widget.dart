import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "2. Graduação (alunos)",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          "Selecione a turma e os alunos que irão graduar neste evento",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 20),

        // --- Dropdown de Turmas ---
        RichText(
          text: const TextSpan(
            text: "Turma ",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            children: [
              TextSpan(text: "*", style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<ClassEntity>(
          value: selectedClass,
          hint: const Text("Selecione a turma"),
          isExpanded: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: classes.map((classEntity) {
            return DropdownMenuItem<ClassEntity>(
              value: classEntity,
              child: Text(classEntity.unitName),
            );
          }).toList(),
          onChanged: (classEntity) {
            formController.selectClass(classEntity);
          },
        ),

        const SizedBox(height: 24),

        // --- Lista de Alunos se houver turma selecionada ---
        if (selectedClass != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: const TextSpan(
                  text: "Alunos que irão graduar:",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(text: " *", style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Botão "Selecionar todos" / "Desmarcar todos"
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => formController.toggleSelectAllMembers(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                selectedIds.length == selectedClass.members.length
                    ? "Desmarcar todos"
                    : "Selecionar todos",
                style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Lista de Cards dos Alunos
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
                onChanged: () => formController.toggleMemberSelection(member.studentId),
              );
            },
          ),
        ],
      ],
    );
  }
}
