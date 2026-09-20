import 'package:sistema_abada_capoeira/features/class/domain/entities/class_professor_entity.dart';

class ClassProfessorEntityModel extends ClassProfessorEntity{

  const ClassProfessorEntityModel({
    required super.professorId,
    required super.professorNickname,
  });

  factory ClassProfessorEntityModel.fromMap(Map<String, dynamic> data){
    return ClassProfessorEntityModel(
      professorId: data['professorId'],
      professorNickname: data['professorNickname'],
    );
  }

}