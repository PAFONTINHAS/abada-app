
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DateController{

  DateController._();

  static Future<void> selectDateAndHour(BuildContext context, Function(DateTime, TimeOfDay) onSelected) async{
    await selectDate(context, (selectedDate) async{
      await selectTime(context, (selectedTime){
        onSelected(selectedDate, selectedTime);
      });
    });
  }

  static Future<void> selectDate(BuildContext context, Function(DateTime) onDateSelected) async{

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if(selectedDate != null){
      onDateSelected(selectedDate);
    }
  }

  static Future<void> selectTime(BuildContext context, Function(TimeOfDay) onTimeSelected) async{

    final TimeOfDay? selectedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if(selectedTime != null){

      onTimeSelected(selectedTime);
    }
  }

  static String formatDDMMYYYY(DateTime? date) {
    
    if(date == null) return '-';

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;

    return '$day/$month/$year';
  }

  static String formatDDMMYYYYHM(DateTime? date) {

    if(date == null) return "-";

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/$year, $hour:$minute';
  }

  static DateTime? toDate(dynamic timestamp) {
    // Se o valor for nulo, retorna nulo imediatamente.
    if (timestamp == null || timestamp is! Timestamp) {
      return null;
    }
    // Se for um Timestamp válido, converte.
    return timestamp.toDate();  
  } 

}

