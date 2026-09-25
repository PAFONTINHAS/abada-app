import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/schedule_entity.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/create_or_edit_class_controller.dart';

class ScheduleViewList extends StatelessWidget {
  const ScheduleViewList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<CreateOrEditClassController>();

    final List<String> days = const [
      'Seg', 'Ter', 'Qua', 
      'Qui', 'Sex', 'Sáb', 'Dom'
    ];

    return Selector<CreateOrEditClassController, List<ScheduleEntity>>(
      selector: (_, controller) => controller.scheduleList,
      builder: (context, scheduleList, child) {
        if (scheduleList.isEmpty) return const SizedBox.shrink();

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: scheduleList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final schedule = scheduleList[index];
            final scheduleColor = controller.getColorForSchedule(schedule);

            final String formattedDays = schedule.scheduleDays
                .map((dayIndex) => days[dayIndex])
                .join(', ');

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: scheduleColor.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: scheduleColor, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: scheduleColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "$formattedDays: ${schedule.openingHour} às ${schedule.closingHour}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                    onPressed: () => controller.removeSchedule(schedule),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}