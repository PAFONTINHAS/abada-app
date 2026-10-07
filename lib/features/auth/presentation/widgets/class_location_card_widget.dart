import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/location/domain/entities/location_entity.dart';
import 'package:sistema_abada_capoeira/features/location/presentation/controllers/student_class_selection_controller.dart';

class ClassLocationCardWidget extends StatelessWidget {
  const ClassLocationCardWidget({
    super.key,
    required this.controller,
    required this.isSelected,
    required this.location,
  });

  final StudentClassSelectionController controller;
  final bool isSelected;

  final LocationEntity location;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: isSelected ? Colors.indigo.shade50 : Colors.white,
      child: ExpansionTile(
        title: Text(
          location.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(location.address),
        onExpansionChanged: (expanded) {
          if (expanded) {
            controller.selectLocation(location.id);
          }
        },
        children: [
          if (isSelected)
            if (controller.isLoadingClasses)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              )
            else if (controller.classesForLocation.isEmpty) ...[
              const Center(
                child: Text("Nenhuma turma encontrada para essa unidade."),
              ),
            ] else
              Column(
                children: controller.classesForLocation.map((classEntity) {
                  return ListTile(
                    title: Text(classEntity.unitName),
                    subtitle: Text(
                      "Prof: ${classEntity.professor.professorNickname}",
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        controller.setLocationIdController(classEntity.classId);
                        controller.setClassNameController(classEntity.unitName);
                        controller.setProfessorIdController(
                          classEntity.professor.professorId,
                        );

                        controller.buildClassRequestEntry();
                      },
                      child: Text(
                        controller.classRequestEntryEntity != null &&
                                controller.classRequestEntryEntity!.classId ==
                                    classEntity.classId
                            ? "Turma Selecionada"
                            : "Selecionar Turma",
                      ),
                    ),
                  );
                }).toList(),
              ),
        ],
      ),
    );
  }
}
