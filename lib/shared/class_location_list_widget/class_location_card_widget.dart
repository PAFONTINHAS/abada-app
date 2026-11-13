import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/location/domain/entities/location_entity.dart';
import 'package:sistema_abada_capoeira/shared/class_location_list_widget/class_location_card_list_tile_widget.dart';
import 'package:sistema_abada_capoeira/features/location/presentation/controllers/student_class_selection_controller.dart';

class ClassLocationCardWidget extends StatelessWidget {
  const ClassLocationCardWidget({
    super.key,
    required this.controller,
    required this.isSelected,
    required this.location,
    this.currentClassEntityId,
    this.lecturedClasses

  });

  final bool isSelected;
  final LocationEntity location;
  final String? currentClassEntityId;
  final List<String>? lecturedClasses;
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
            color: isSelected
                ? Colors.white
                : theme.colorScheme.onSurfaceVariant,
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
            controller.selectLocation(location.id, currentClassEntityId, lecturedClasses);
          } else if (isSelected) {
            controller.selectLocation('', currentClassEntityId, lecturedClasses);
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

                    final isClassSelected =
                        (controller.classRequestEntryEntity != null &&
                        controller.classRequestEntryEntity!.classId ==
                            classEntity.classId);

                    return ClassLocationCardListTileWidget(
                      classEntity: classEntity,
                      isClassSelected: isClassSelected,
                      controller: controller,
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }
}
