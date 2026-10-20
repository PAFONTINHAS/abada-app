import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/shared/inputs/file_picker_widget.dart';
import 'package:sistema_abada_capoeira/shared/buttons/custom_text_button.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/features/events/domain/entities/event_type.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/models/event_phases.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_member_entity.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_phase_progress_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_products_section_widget.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_phases_controller.dart';
import 'package:sistema_abada_capoeira/features/location/presentation/controllers/create_location_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_page_address_field_widget.dart';

class EventFormPage extends StatelessWidget {
  const EventFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final eventFormPhasesController = context.read<EventFormPhasesController>();
    final formController = context.read<EventFormController>();

    return Scaffold(
      appBar: AppBar(title: Text("Criar evento")),
      body: StandardScaffoldBodyWidget(
        child: Selector<EventFormPhasesController, EventPhases>(
          selector: (_, controller) => controller.currentPhase,
          builder: (context, currentPhase, child) {

            final bool isGraduationEvent = 
              currentPhase == EventPhases.thirdPhase && 
              formController.eventType == EventType.GRADUATION;

            final bool isEventRevisionPhase = 
              currentPhase == EventPhases.fourthPhase || 
              currentPhase == EventPhases.thirdPhase && 
              formController.eventType == EventType.COMPETITION;

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                EventPhaseProgressWidget(),

                if(currentPhase == EventPhases.firstPhase) const EventFormFirstPhase(),

                if(currentPhase == EventPhases.secondPhase) const EventFormSecondPhase(),

                if(isGraduationEvent) const EventFormGraduationPhaseWidget(),

                if(isEventRevisionPhase) const EventFormRevisionPhaseWidget(),
               

                CustomTextButton(
                  text: "Criar Evento",
                  onPressed: () => eventFormPhasesController.nextFormPhase(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}


class EventFormRevisionPhaseWidget extends StatelessWidget {
  const EventFormRevisionPhaseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Text("XENTEEEE, QUE DEMAIXX!")
      ],
    );
  }
}


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

              return _MemberGraduationTile(
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

class _MemberGraduationTile extends StatelessWidget {
  final ClassMemberEntity member;
  final bool isSelected;
  final VoidCallback onChanged;

  const _MemberGraduationTile({
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

class EventFormSecondPhase extends StatelessWidget {
  const EventFormSecondPhase({super.key});

  @override
  Widget build(BuildContext context) {
    
    final formController = context.read<EventFormController>();
    final moneyMaskFormatter = CurrencyTextInputFormatter.currency(
      locale: 'pt_BR', // Defina o local (ex: pt_BR para Real)
      symbol: 'R\$ ',    // Símbolo da moeda
      decimalDigits: 2,
    );


    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        
        Text("Tipo de evento"),
        DropdownFlutter(
          hintText: "Selecione o tipo de evento",
          // initialItem: EventTypeExtensdfdfion.convertToUIText(EventType.COMPETITION),
          items: [
            EventTypeExtension.convertToUIText(EventType.COMPETITION),
            EventTypeExtension.convertToUIText(EventType.GRADUATION),
          ],
          onChanged: (eventType) {
            if (eventType == null) return;

            formController.setEventType(
              EventTypeExtension.getFromString(eventType),
            );
          },
        ),

        CustomTextInput(
          label: "Valor do Evento (opcional)",
          keyboardType: TextInputType.numberWithOptions(),
          hintText: "R\$ 0,00",
          mask: moneyMaskFormatter,
          hasMask: true,
          controller: formController.eventValue,
        ),

        const EventProductsSectionWidget()

      ],
    );
  }
}

class EventFormFirstPhase extends StatelessWidget {
  const EventFormFirstPhase({super.key});

  @override
  Widget build(BuildContext context) {
    final formController = context.read<EventFormController>();
    final createLocationController = context.read<CreateLocationController>();

    return Column(
      children: [
        CustomTextInput(
          label: "Nome do Evento",
          controller: formController.eventName,
          hintText: "Batizado e Troca de Cordas 2026",
        ),

        CustomTextInput(
          label: "Descrição do Evento",
          controller: formController.eventDescription,
          hintText: "Descreva o que ocorrerá no evento",
        ),

        EventFormPageAddressFieldWidget(
          createLocationController: createLocationController,
          formController: formController,
        ),

        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  await DateController.selectDateAndHour(context, (
                    selectedDate,
                    selectedTime,
                  ) {
                    formController.setEventInitDate(selectedDate, selectedTime);
                  });
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "Data de Início",
                    labelStyle: TextStyle(fontSize: 16),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                  ),
                  child: Selector<EventFormController, DateTime?>(
                    selector: (_, controller) => controller.eventInitDate,
                    builder: (context, eventInitDate, child) =>
                        Text(DateController.formatDDMMYYYYHM(eventInitDate)),
                  ),
                ),
              ),
            ),

            SizedBox(width: 20),

            Expanded(
              child: InkWell(
                onTap: () async {
                  await DateController.selectDateAndHour(context, (
                    selectedDate,
                    selectedTime,
                  ) {
                    formController.setEventEndingDate(
                      selectedDate,
                      selectedTime,
                    );
                  });
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "Data final",
                    labelStyle: TextStyle(fontSize: 16),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                  ),
                  child: Selector<EventFormController, DateTime?>(
                    selector: (_, controller) => controller.eventInitDate,
                    builder: (context, eventInitDate, child) =>
                        Text(DateController.formatDDMMYYYYHM(eventInitDate)),
                  ),
                ),
              ),
            ),
          ],
        ),

        FilePickerWidget(
          label: 'Imagem do Evento (opcional)',
          hintText: 'Selecione a imagem do evento',
          fileType: FileType.image,
          imageOnly: true,
          showPreview: true,
          currentFile: formController.eventImage,
          onFileSelected: (file) {
            formController.setEventImage(file);
          },
        ),
      ],
    );
  }
}
