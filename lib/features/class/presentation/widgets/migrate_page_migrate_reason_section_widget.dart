import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_migration_controller.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';

class MigratePageMigrateReasonSectionWidget extends StatelessWidget {
  const MigratePageMigrateReasonSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final classMigrationController = context.read<ClassMigrationController>();
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.edit_note_rounded, color: ColorConstants.indigoColor),
            const SizedBox(width: 8),
            const Text(
              "Motivo da Transferência",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),

        CustomTextInput(
          label: "Motivo (Opcional)",
          hintText: "Ex: Mudança de horário, nova graduação, troca de academia...",
          controller: classMigrationController.migrationReason,
          maxLines: 4,
        ),
      ],
    );
  }
}
