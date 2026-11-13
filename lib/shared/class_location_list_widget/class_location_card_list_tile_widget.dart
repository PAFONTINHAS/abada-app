import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/location/presentation/controllers/student_class_selection_controller.dart';

class ClassLocationCardListTileWidget extends StatelessWidget {
  const ClassLocationCardListTileWidget({
    super.key,
    required this.classEntity,
    required this.isClassSelected,
    required this.controller,
  });

  final bool isClassSelected;
  final ClassEntity classEntity;
  final StudentClassSelectionController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        classEntity.unitName,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Row(
        children: [
          Icon(
            Icons.person_outline_rounded,
            size: 14,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(width: 4),
          
          Expanded(
            child: Text(
              "Prof: ${classEntity.professor.professorNickname}",
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          
        ],
      ),
      trailing: isClassSelected
        ? FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.check_rounded, size: 16),
            label: const Text("Selecionada"),
            style: FilledButton.styleFrom(
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          )
        : OutlinedButton(
            onPressed: () {
              controller.setLocationIdController(classEntity.classId);
              controller.setClassNameController(classEntity.unitName);
              controller.setProfessorIdController(
                classEntity.professor.professorId,
              );
              controller.buildClassRequestEntry();
            },
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text("Selecionar"),
          ),
    );
  }
}
