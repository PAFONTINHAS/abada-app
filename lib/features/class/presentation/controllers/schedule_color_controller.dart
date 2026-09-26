import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/schedule_entity.dart';

class ScheduleColorController {

   final List<Color> scheduleColors = const [
    Colors.orange,
    Colors.blue,
    Colors.purple,
    Colors.teal,
    Colors.redAccent,
    Colors.indigo,
    Colors.amber,
  ];


  Color getColorForSchedule(ScheduleEntity schedule, List<ScheduleEntity> scheduleList){
    final index = scheduleList.indexOf(schedule);

    if(index == -1) return Colors.grey;

    return scheduleColors[index % scheduleColors.length];
  }

  ScheduleEntity? getScheduleForDay(int dayIndex, List<ScheduleEntity> scheduleList) {
    for (final schedule in scheduleList) {
      if (schedule.scheduleDays.contains(dayIndex)) {
        return schedule;
      }
    }
    return null;
  }
}