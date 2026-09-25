import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/app_spacing.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/utils/message_handler.dart';
import 'package:sistema_abada_capoeira/core/utils/time_picker_helper.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/student_page_button_widget.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/custom_text_input.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/weekdays_checkbox_list_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/create_or_edit_class_controller.dart';

class CreateOrEditScheduleWidget extends StatelessWidget {
  const CreateOrEditScheduleWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = context.read<CreateOrEditClassController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(28, 79, 39, 211),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: AppSpacing.symmetricH12V6,
            child: Column(
              children: [
                Text(
                  "Agenda",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Text(
                  "Selecione os dias da semana e os horários da turma",
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 20,),       

        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  String? pickedTime = await TimePickerHelper.selectTime(context,);
                  if (pickedTime != null) {
                    // controller.updateInterval(controller.selectedDiaTrabalho.diaSemana, pausa.intervalId, novoInicio: pickedTime);
                    controller.setOpeningHourController(pickedTime);
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "Horário de Início", 
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Deixa menorzinho
                  ),
                  child: Selector<CreateOrEditClassController, String>(
                    selector: (_, controller) => controller.openingHourController.text,
                    builder: (context, openingHour, child) => Text(openingHour),
                  )
                ),
              ),
            ),

            SizedBox(width: 20),

            Expanded(
              child: InkWell(
                onTap: () async {
                  String? pickedTime = await TimePickerHelper.selectTime(context,);

                  
                  if (pickedTime != null && context.mounted) {

                    final openingHour = TimePickerHelper.getTimeFromString(controller.openingHourController.text);
                    final closingHour = TimePickerHelper.getTimeFromString(pickedTime);

                    final closingHourIsGreaterThanOpeningHour = TimePickerHelper.compareTimes(openingHour, closingHour) == 0;
                    final closingHourIsEqualToOpeningHour = TimePickerHelper.compareTimes(openingHour, closingHour) == 1;


                    if(closingHourIsEqualToOpeningHour || closingHourIsGreaterThanOpeningHour){
                      MessageHandler.showError(
                        context,
                        "Horario de término não pode ser menor ou igual ao horário de início",
                      );

                      return;
                    }

                    controller.setClosingHourController(pickedTime);
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "Horário de Término", 
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Deixa menorzinho
                  ),
                  child: Selector<CreateOrEditClassController, String>(
                    selector: (_, controller) => controller.closingHourController.text,
                    builder: (context, closingHour, child) => Text(closingHour),
                  )
                ),
              ),
            ),

          ],
        ),

        SizedBox(height: 15),
        
        Align(
          alignment: Alignment.center,
          child: WeekdaysCheckboxListWidget() ,
        ),
        

        StudentPageButtonWidget(
          icon: Icons.add,
          onPressed: () => controller.addNewSchedule(context),
          buttonTitle: "Adicionar outro horário",
          buttonColor: ColorConstants.indigoColor,
        ),

      ],
    );
  }
}

