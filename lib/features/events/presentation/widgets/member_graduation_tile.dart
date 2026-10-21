import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:sistema_abada_capoeira/core/utils/mask_formatter.dart';
import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_first_phase_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_second_phase_widget.dart';
import 'package:sistema_abada_capoeira/shared/inputs/file_picker_widget.dart';
import 'package:sistema_abada_capoeira/shared/buttons/custom_text_button.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/models/event_phases.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_member_entity.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_products_item.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_phase_progress_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_products_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_products_section_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_phases_controller.dart';
import 'package:sistema_abada_capoeira/features/location/presentation/controllers/create_location_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_page_address_field_widget.dart'; 

class MemberGraduationTileWidget extends StatelessWidget {
  final ClassMemberEntity member;
  final bool isSelected;
  final VoidCallback onChanged;

  const MemberGraduationTileWidget({
    super.key,
    required this.member,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CheckboxListTile(
        value: isSelected,
        onChanged: (_) => onChanged(),
        activeColor: Colors.deepPurple,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          member.name ?? "Estudante", // Ajuste para o campo de nome correto da sua entity ClassMemberEntity
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Text(
          // Exemplo dinâmico para a troca de corda conforme layout
          "De ${member.belt} para ROXA",
          style: TextStyle(
            color: Colors.grey.shade600,
            fontStyle: FontStyle.italic,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}