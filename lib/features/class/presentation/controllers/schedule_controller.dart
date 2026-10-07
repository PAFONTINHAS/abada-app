import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/utils/message_handler.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/schedule_entity.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/schedule_color_controller.dart';

class ScheduleController extends ChangeNotifier{

  List<bool> _weekDays = List.generate(7, (index) => false);
  List<bool> get weekDays => _weekDays; 

  List<ScheduleEntity> _scheduleList = [];
  List<ScheduleEntity> get scheduleList => _scheduleList;

  ScheduleEntity? _currentScheduleEntity;
  ScheduleEntity? get currentScheduleEntity => _currentScheduleEntity;

  TextEditingController openingHourController = TextEditingController();
  TextEditingController closingHourController= TextEditingController();

  ScheduleColorController scheduleColorController = ScheduleColorController();

  void beginEditing(List<ScheduleEntity> scheduleListToEdit){

    _scheduleList = List.from(scheduleListToEdit);

    notifyListeners();
  }

  void setOpeningHourController(String value){

    if(value.isEmpty) return;

    openingHourController.text = value;

    notifyListeners();

  }

  void clearFields(){
    _currentScheduleEntity = null;
    _scheduleList.clear();
    openingHourController.clear();
    closingHourController.clear();
    notifyListeners();
  }  

  void setClosingHourController(String value){

    if(value.isEmpty) return;

    closingHourController.text = value;

    notifyListeners();
  }

 
  void setWeekday(int day, bool? value){

    if(value == null) return;

    if(scheduleColorController.getScheduleForDay(day, _scheduleList) != null) return;

    final currentWeekdays = List<bool>.from(_weekDays);

    currentWeekdays[day] = value;

    _weekDays = List<bool>.from(currentWeekdays);

    notifyListeners();
  }

  Future<bool> addNewSchedule(BuildContext context) async {

    if (openingHourController.text.isEmpty || closingHourController.text.isEmpty){
      
      MessageHandler.showWarning(context, "Preencha os campos de horário");

      return false; 
    }

    for(final schedule in _scheduleList){

      final bool isSameOpeningHour = openingHourController.text == schedule.openingHour;
      final bool isSameClosingHour = closingHourController.text == schedule.closingHour;

      if(isSameClosingHour && isSameOpeningHour){

        MessageHandler.showWarning(context, "Horários de início e de término já selecionados");

        return false;
      }

    }

    List<int> scheduleDays = _fetchScheduleDays();

    if (scheduleDays.isEmpty){
      MessageHandler.showWarning(context, "Selecione ao menos um dia");

      return false;
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

    return true;
  }


  void removeSchedule(ScheduleEntity schedule) {
    _scheduleList = List.from(_scheduleList)..removeWhere((item) => item.scheduleId == schedule.scheduleId);
    notifyListeners();
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