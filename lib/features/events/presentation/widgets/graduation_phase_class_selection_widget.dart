import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_graduation_controller.dart';

class GraduationPhaseClassSelectionWidget extends StatelessWidget {
  const GraduationPhaseClassSelectionWidget({
    super.key,
    required this.selectedClass,
    required this.classes,
  });

  final ClassEntity? selectedClass;
  final List<ClassEntity> classes;

  @override
  Widget build(BuildContext context) {
    final graduationController = context.watch<EventFormGraduationController>();

    return DropdownButtonFormField<ClassEntity>(
      initialValue: selectedClass,
      isExpanded: true,
      hint: const Text(
        "Selecione a turma para graduação",
        style: TextStyle(color: ColorConstants.textSecondary, fontSize: 14),
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
          child: Text(classEntity.unitName, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: (classEntity) {
        graduationController.selectClass(classEntity);
      },
    );
  }
}
