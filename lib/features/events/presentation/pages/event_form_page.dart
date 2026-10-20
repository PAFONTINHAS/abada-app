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
import 'package:sistema_abada_capoeira/features/events/presentation/models/event_phases.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
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
    return Column(
      children: [

        Text("XENTE!!!")
        
      ],
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
