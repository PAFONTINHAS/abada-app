import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/app_spacing.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/utils/message_handler.dart';
import 'package:sistema_abada_capoeira/core/utils/time_picker_helper.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/schedule_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/schedule_view_list_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/student_page_button_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/widgets/weekdays_checkbox_list_widget.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/create_form_controller.dart';

class CreateOrEditScheduleWidget extends StatelessWidget {
  const CreateOrEditScheduleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduleController = context.read<ScheduleController>();
    final createOrEditClassController = context.read<ClassFormController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. TÍTULO E LISTA DE HORÁRIOS SALVOS

        const SizedBox(height: 10),
        
        // Exibe os horários já adicionados logo abaixo do título
        const ScheduleViewListWidget(),
        
        const SizedBox(height: 20),

        // 2. CARD DE CRIAÇÃO DE NOVO HORÁRIO
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white, // Fundo destacado
            border: Border.all(color: Colors.grey.shade300), // Borda sutil
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ]
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(28, 79, 39, 211),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: AppSpacing.symmetricH12V8,
                    child: Column(
                      children: [
                        Text(
                          "Agenda",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          "Selecione os dias da semana e os horários da turma",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
                // A. Dias da semana primeiro (Ordem lógica mental)
                const SizedBox(height: 20),

                const Align(
                  alignment: Alignment.center,
                  child: WeekdaysCheckboxListWidget(),
                ),
                
                const SizedBox(height: 20),

                // B. Seletores de Horário Início e Término
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          String? pickedTime = await TimePickerHelper.selectTime(context);
                          if (pickedTime != null) {
                            scheduleController.setOpeningHourController(pickedTime);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: "Início", 
                            hintText: "14:30",
                            labelStyle: TextStyle(fontSize: 16),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          ),
                          child: Selector<ScheduleController, String>(
                            selector: (_, controller) => controller.openingHourController.text,
                            builder: (context, openingHour, child) => Text(openingHour),
                          )
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          String? pickedTime = await TimePickerHelper.selectTime(context);
                          if (pickedTime != null && context.mounted) {
                            final openingHour = TimePickerHelper.getTimeFromString(scheduleController.openingHourController.text);
                            final closingHour = TimePickerHelper.getTimeFromString(pickedTime);

                            final closingHourIsGreaterThanOpeningHour = TimePickerHelper.compareTimes(openingHour, closingHour) == 0;
                            final closingHourIsEqualToOpeningHour = TimePickerHelper.compareTimes(openingHour, closingHour) == 1;

                            if (closingHourIsEqualToOpeningHour || closingHourIsGreaterThanOpeningHour) {
                              MessageHandler.showError(
                                context,
                                "Horario de término não pode ser menor ou igual ao horário de início",
                              );
                              return;
                            }
                            scheduleController.setClosingHourController(pickedTime);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: "Término", 
                            hintText: "19:30",
                            labelStyle: TextStyle(fontSize: 16),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          ),
                          child: Selector<ScheduleController, String>(
                            selector: (_, controller) => controller.closingHourController.text,
                            builder: (context, closingHour, child) => Text(closingHour),
                          )
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // C. Botão de Ação no final do fluxo do Card
                Align(
                  alignment: Alignment.centerRight,
                  child: StudentPageButtonWidget(
                    icon: Icons.add,
                    onPressed: () {
                      scheduleController.addNewSchedule(context);
                    },
                    buttonTitle: "Adicionar à agenda",
                    buttonColor: ColorConstants.indigoColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}