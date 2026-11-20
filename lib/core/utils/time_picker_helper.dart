import 'package:flutter/material.dart';

class TimePickerHelper {

  TimePickerHelper._();

  static Future<String?> selectTime(BuildContext context) async {


    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFEC489A), // cor dos ponteiros e seleção
              onPrimary: Colors.white,
              onSurface: Colors.black, // cor dos números
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final String formattedTime = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";

      return formattedTime;
    }

    return null;
  }

  static TimeOfDay? getTimeFromString(String? time){

    if(time == null) return null;

    final splitedTime = time.split(":");

    return TimeOfDay(
      hour: int.parse(splitedTime[0]),
      minute: int.parse(splitedTime[1]),
    );
  }

  static int compareTimes(TimeOfDay? firstTime, TimeOfDay? secondTime){

    if(firstTime == null || secondTime == null) return -1;


    if(firstTime.isBefore(secondTime)) return -1;

    if(firstTime.isAtSameTimeAs(secondTime)) return 0;

    if(firstTime.isAfter(secondTime)) return 1;

    return -1;

  }
}


