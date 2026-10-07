import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/schedule_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_professor_entity.dart';

class ClassFormController extends ChangeNotifier{

  TextEditingController classUnitController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  bool _isEditing = false;
  bool get isEditing => _isEditing;

  ClassEntity? _classForEdit;
  ClassEntity? get classForEdit => _classForEdit;
  

  void beginEditing(ClassEntity classEntity){

    _isEditing = true;
    _classForEdit = classEntity;

    classUnitController.text = classEntity.unitName;
    locationController.text = classEntity.locationId;

    notifyListeners();
  }

  void setClassUnitController (String value){

    classUnitController.text = value;

    notifyListeners();
  }

  void setLocationController (String value){

    if(value.isEmpty) return; 

    locationController.text = value;

    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();

    classUnitController.dispose();
    locationController.dispose();
  }

  void clearControllers(){
    classUnitController.clear();
    locationController.clear();

    notifyListeners();
  }

  ClassEntity buildClassEntity(
    List<ScheduleEntity> scheduleList,
    UserProfileEntity userProfileEntity,
    String locationId,
    String locationAddress,
  ){

    final ClassProfessorEntity classProfessorEntity = ClassProfessorEntity(
      professorId: userProfileEntity.uid,
      professorNickname: userProfileEntity.nickname,
    );

    return ClassEntity(
      classId: '',
      locationId: locationId,
      professor: classProfessorEntity,
      locationAddress:locationAddress,
      unitName: classUnitController.text,
      schedule: List<ScheduleEntity>.from(scheduleList),
    );
  }

  ClassEntity? buildUpdatedClassEntity(List<ScheduleEntity> scheduleList){

    if(_classForEdit == null) return null;

    final updatedClass = _classForEdit!.copyWith(
      unitName: classUnitController.text,
      locationId: locationController.text,
      schedule: List<ScheduleEntity>.from(scheduleList)
    );

    return updatedClass;

  }

}