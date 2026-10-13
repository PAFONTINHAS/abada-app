import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/utils/date_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_phases_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_phase_progress_widget.dart';
import 'package:sistema_abada_capoeira/shared/body/standard_scaffold_body_widget.dart';
import 'package:sistema_abada_capoeira/shared/buttons/custom_text_button.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/controllers/event_form_controller.dart';
import 'package:sistema_abada_capoeira/features/location/presentation/controllers/create_location_controller.dart';
import 'package:sistema_abada_capoeira/features/events/presentation/widgets/event_form_page_address_field_widget.dart';

class EventFormPage extends StatelessWidget {
  const EventFormPage({super.key});

  @override
  Widget build(BuildContext context) {

    final formController = context.read<EventFormController>();
    final createLocationController = context.read<CreateLocationController>();
    final eventFormPhasesController = context.read<EventFormPhasesController>();

    return Scaffold(
      appBar: AppBar(title: Text("Criar evento")),
      body: StandardScaffoldBodyWidget(
        child: Column(
          children: [

            EventPhaseProgressWidget(),

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
                      await DateController.selectDateAndHour(context, (selectedDate, selectedTime) {
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

                SizedBox(width: 20,),

                Expanded(
                  child: InkWell(
                    onTap: () async {
                      await DateController.selectDateAndHour(context, (selectedDate, selectedTime) {
                        formController.setEventEndingDate(selectedDate, selectedTime);
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


            CustomTextButton(text: "Criar Evento", onPressed: () => eventFormPhasesController.nextFormPhase())
            
          ],
        ),
      ),
    );
  }
}