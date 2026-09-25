import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/utils/message_handler.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/schedule_entity.dart';

class ScheduleController extends ChangeNotifier{


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

  Future<void> addNewSchedule({
    required BuildContext context,
    required TextEditingController openingHourController,
    required TextEditingController closingHourController,
  }) async {

    if (openingHourController.text.isEmpty || closingHourController.text.isEmpty){

      return MessageHandler.showWarning(context, "Preencha os campos de horário");
      
    }

    for(final schedule in _scheduleList){

      final bool isSameOpeningHour = openingHourController.text == schedule.openingHour;
      final bool isSameClosingHour = closingHourController.text == schedule.closingHour;

      if(isSameClosingHour && isSameOpeningHour){
        return MessageHandler.showWarning(context, "Horários de início e de término já selecionados");
      }

    }

    List<int> scheduleDays = _fetchScheduleDays();

    if (scheduleDays.isEmpty){
      return MessageHandler.showWarning(context, "Selecione ao menos um dia");
    } // Evita salvar sem nenhum dia selecionado

    _currentScheduleEntity = ScheduleEntity(
      scheduleId: "schedule_${_scheduleList.length}_${DateTime.now().millisecondsSinceEpoch}",
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
    _scheduleList = List.from(_scheduleList)..removeWhere((item) => item.scheduleId == schedule.scheduleId);
    notifyListeners();
  }

  List<ScheduleEntity>? buildScheduleController({
    required BuildContext context,
    required TextEditingController openingHourController,
    required TextEditingController closingHourController,
  }) {

    final bool openingHourNotEmpty = openingHourController.text.isNotEmpty;
    final bool closingHourNotEmpty = closingHourController.text.isNotEmpty;

    if(openingHourNotEmpty || closingHourNotEmpty){

      if (weekDays.isNotEmpty){
        
        MessageHandler.showWarning(
          context,
          "Selecione os dias para o horário selecionado",
        );

        return null;
      }

      final List<int> scheduleDays = _fetchScheduleDays();

      final currentScheduleEntity = ScheduleEntity(
        scheduleId: "schedule_${_scheduleList.length}_${DateTime.now().millisecondsSinceEpoch}",
        openingHour: openingHourController.text,
        closingHour: closingHourController.text,
        scheduleDays: scheduleDays,
      );

      _scheduleList.add(currentScheduleEntity);
    }

    return _scheduleList;
  }

  List<int> _fetchScheduleDays(){

    if(_weekDays.isEmpty) return [];

    List<int> scheduleDays = [];
      
    for (int i = 0; i < _weekDays.length; i++) {
      if (_weekDays[i]) {
        scheduleDays.add(i);
      }
    }

    return scheduleDays;
  }

} 