import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/utils/message_handler.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_professor_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/schedule_entity.dart';
import 'package:sistema_abada_capoeira/features/profile/domain/entities/user_profile_entity.dart';

class CreateOrEditClassController extends ChangeNotifier{

  TextEditingController classUnitController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  
  TextEditingController openingHourController = TextEditingController();
  TextEditingController closingHourController= TextEditingController();

  


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


  Future<ClassEntity?> buildClassEntity(
    BuildContext context,
    List<ScheduleEntity> scheduleList,
    UserProfileEntity userProfileEntity,
  ) async {

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
      schedule: scheduleList,
      professor: classProfessorEntity,
    );



  }

}