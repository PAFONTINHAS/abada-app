import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/schedule_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_professor_entity.dart';

class CreateOrEditClassController extends ChangeNotifier{

  TextEditingController classUnitController = TextEditingController();
  TextEditingController locationController = TextEditingController();

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

  @override
  void dispose() {
    // TODO: implement dispose
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
    BuildContext context,
    List<ScheduleEntity> scheduleList,
    UserProfileEntity userProfileEntity,
  ){

    final ClassProfessorEntity classProfessorEntity = ClassProfessorEntity(
      professorId: userProfileEntity.uid,
      professorNickname: userProfileEntity.nickname,
    );

    return ClassEntity(
      classId: '',
      cep: '',
      city: '',
      region: '',
      state: '',
      location: locationController.text,
      unitName: classUnitController.text,
      schedule: List<ScheduleEntity>.from(scheduleList),
      professor: classProfessorEntity,
    );
  }

}