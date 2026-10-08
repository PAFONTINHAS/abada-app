import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/shared/class_location_list_widget/classes_location_list_widget.dart';

class MigratePageClassSelectionSectionWidget extends StatelessWidget {
  const MigratePageClassSelectionSectionWidget({
    super.key,
    required this.currentClassId,
    required this.lecturedClasses,
  });

  final String currentClassId;
  final List<String> lecturedClasses;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.groups_rounded, color: ColorConstants.indigoColor),
            const SizedBox(width: 8),
            const Text(
              "Selecione a Nova Turma",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(8.0),
          child: ClassesLocationListWidget(
            currentClassEntityId: currentClassId,
            lecturedClasses: lecturedClasses,
          ),
        ),
      ],
    );
  }
}
