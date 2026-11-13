import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/schedule_color_controller.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/schedule_controller.dart';

class WeekdaysCheckboxListWidget extends StatelessWidget {
  const WeekdaysCheckboxListWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final List<String> days = const [
      'Seg', 'Ter', 'Qua', 'Qui', 
      'Sex', 'Sáb', 'Dom'
    ];

    final ScheduleColorController scheduleColorController = ScheduleColorController();
    return Consumer<ScheduleController>(
      builder: (context, controller, child) {
        final weekdays = controller.weekDays;


        return Wrap(
          spacing: 6,
          runSpacing: 8.0,
          children: List.generate(7, (index) {
            final blockingSchedule = scheduleColorController.getScheduleForDay(
              index,
              controller.scheduleList,
            );
            final isBlocked = blockingSchedule != null;
            final isChecked = weekdays[index];

            // Define a cor de destaque (Cor do horário bloqueador ou neutra)
            Color? cardColor;
            if (isBlocked) {
              cardColor = scheduleColorController
                  .getColorForSchedule(
                    blockingSchedule,
                    controller.scheduleList,
                  )
                  .withAlpha(40);
            }

            Color activeColor = isBlocked
                ? scheduleColorController.getColorForSchedule(blockingSchedule, controller.scheduleList)
                : ColorConstants.indigoColor;

            return Column(
              children: [
                Text(
                  days[index],
                  style: TextStyle(
                    fontWeight: isBlocked ? FontWeight.bold : FontWeight.normal,
                    color: isBlocked
                        ? scheduleColorController.getColorForSchedule(
                            blockingSchedule,
                            controller.scheduleList,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: isBlocked
                        ? Border.all(
                            color: scheduleColorController.getColorForSchedule(
                              blockingSchedule,
                              controller.scheduleList,
                            ),
                            width: 1.5,
                          )
                        : null,
                  ),
                  child: Checkbox(
                    value: isBlocked ? true : isChecked,
                    activeColor: activeColor,
                    onChanged: (isBlocked)
                        ? null // Desabilita clique se estiver bloqueado ou se horários estiverem vazios
                        : (value) {
                            controller.setWeekday(index, value);
                          },
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }
}