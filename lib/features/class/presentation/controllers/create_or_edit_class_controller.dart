import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/utils/message_handler.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/schedule_entity.dart';

class CreateOrEditClassController extends ChangeNotifier{

  TextEditingController classUnitController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  
  TextEditingController openingHourController = TextEditingController();
  TextEditingController closingHourController= TextEditingController();

  List<bool> _weekDays = List.generate(7, (index) => false);
  List<bool> get weekDays => _weekDays; 

  List<ScheduleEntity> _scheduleList = [];
  List<ScheduleEntity> get scheduleList => _scheduleList;

  ScheduleEntity? _currentScheduleEntity;
  ScheduleEntity? get currentScheduleEntity => _currentScheduleEntity;

  final List<Color> scheduleColors = const [
    Colors.orange,
    Colors.blue,
    Colors.purple,
    Colors.teal,
    Colors.redAccent,
    Colors.indigo,
    Colors.amber,
  ];


  Color getColorForSchedule(ScheduleEntity schedule){
    final index = _scheduleList.indexOf(schedule);

    if(index == -1) return Colors.grey;

    return scheduleColors[index % scheduleColors.length];
  }

  ScheduleEntity? getScheduleForDay(int dayIndex) {
    for (final schedule in _scheduleList) {
      if (schedule.scheduleDays.contains(dayIndex)) {
        return schedule;
      }
    }
    return null;
  }


  void setWeekday(int day, bool? value){

    if(value == null) return;

    if(getScheduleForDay(day) != null) return;

    final currentWeekdays = List<bool>.from(_weekDays);

    currentWeekdays[day] = value;

    _weekDays = List<bool>.from(currentWeekdays);

    notifyListeners();
  }

  void setClassUnitController (String value){

    // if(value.isEmpty) return; 

    classUnitController.text = value;

    notifyListeners();
  }

  void setLocationController (String value){

    if(value.isEmpty) return; 

    locationController.text = value;

    notifyListeners();
  }

  void setOpeningHourController(String value){

    if(value.isEmpty) return;

    openingHourController.text = value;

    notifyListeners();

  }
  
  void setClosingHourController(String value){

    if(value.isEmpty) return;

    closingHourController.text = value;

    notifyListeners();
  }

  void addNewSchedule(BuildContext context) {

    if (openingHourController.text.isEmpty || closingHourController.text.isEmpty) return;

    for(final schedule in _scheduleList){

      final bool isSameOpeningHour = openingHourController.text == schedule.openingHour;
      final bool isSameClosingHour = closingHourController.text == schedule.closingHour;

      if(isSameClosingHour && isSameOpeningHour){
        return MessageHandler.showWarning(context, "Horários de início e de término já selecionados");
      }

    }

    List<int> scheduleDays = [];

    for (int i = 0; i < _weekDays.length; i++) {
      if (_weekDays[i]) {
        scheduleDays.add(i);
      }
    }

    if (scheduleDays.isEmpty) return; // Evita salvar sem nenhum dia selecionado

    _currentScheduleEntity = ScheduleEntity(
      id: "schedule_${_scheduleList.length}_${DateTime.now().millisecondsSinceEpoch}",
      openingHour: openingHourController.text,
      closingHour: closingHourController.text,
      scheduleDays: scheduleDays,
    );

    _scheduleList = List.from(_scheduleList)..add(_currentScheduleEntity!);

    // Reseta o formulário para o próximo horário
    _weekDays = List.generate(7, (index) => false);
    openingHourController.clear();
    closingHourController.clear();

    notifyListeners();
  }


  void removeSchedule(ScheduleEntity schedule) {
    _scheduleList = List.from(_scheduleList)..removeWhere((item) => item.id == schedule.id);
    notifyListeners();
  }

}