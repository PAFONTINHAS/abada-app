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

  final bool isSelected;
  final LocationEntity location;
  final StudentClassSelectionController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: isSelected ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected 
              ? primaryColor 
              : theme.colorScheme.outlineVariant.withOpacity(0.5),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      color: isSelected 
          ? primaryColor.withOpacity(0.04) 
          : theme.colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        // CHAVE MÁGICA: Força o ExpansionTile a reconstruir e sincronizar 
        // o estado visual interno quando o 'isSelected' muda!
        key: Key('location_tile_${location.id}_$isSelected'),
        initiallyExpanded: isSelected,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: const Border(),
        leading: CircleAvatar(
          backgroundColor: isSelected 
              ? primaryColor 
              : theme.colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.location_on_rounded,
            color: isSelected ? Colors.white : theme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ),
        title: Text(
          location.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? primaryColor : theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Text(
            location.address,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        onExpansionChanged: (expanded) {
          if (expanded) {
            controller.selectLocation(location.id);
          } else if (isSelected) {
            // Opcional: Desseleciona no controller se o usuário fechar manualmente o card expandido
            controller.selectLocation(''); // Ou o método que limpa a seleção no seu controller
          }
        },
        children: [
          if (isSelected)
            if (controller.isLoadingClasses)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Center(child: CircularProgressIndicator(strokeWidth: 3)),
              )
            else if (controller.classesForLocation.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Nenhuma turma encontrada para essa unidade.",
                  style: TextStyle(
                    color: theme.colorScheme.outline,
                    fontSize: 13,
                  ),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLowest,
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.outlineVariant.withOpacity(0.3),
                    ),
                  ),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.classesForLocation.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: theme.colorScheme.outlineVariant.withOpacity(0.2),
                  ),
                  itemBuilder: (context, index) {
                    final classEntity = controller.classesForLocation[index];
                    final isClassSelected = controller.classRequestEntryEntity != null &&
                        controller.classRequestEntryEntity!.classId == classEntity.classId;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, 
                        vertical: 4,
                      ),
                      title: Text(
                        classEntity.unitName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 14,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Prof: ${classEntity.professor.professorNickname}",
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurfaceVariant,
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
                  },
                ),
              ),
        ],
      ),
    );
  }
}