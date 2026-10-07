import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';

class CreateClassUsecaseValidator {

  CreateClassUsecaseValidator._();


  static String? validate(ClassEntity classEntity){


    if(classEntity.unitName.isEmpty) return "Nome da unidade não pode ser vazio";

    if(classEntity.locationId.isEmpty) return "Endereço da unidade não pode ser vazio";

    if(classEntity.schedule.isEmpty) return "Agenda não pode ser vazia";
    
    return null;


  }

}