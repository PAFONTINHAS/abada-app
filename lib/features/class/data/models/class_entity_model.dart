import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/features/class/data/models/class_professor_entity_model.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_member_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_professor_entity.dart';

class ClassEntityModel extends ClassEntity{

  const ClassEntityModel({
    required super.classId,
    required super.cep,
    required super.city,
    required super.region,
    required super.state,
    required super.location,
    required super.unitName,
    required super.schedule,
    required super.professorClassEntity,
    super.members
  }); 


  factory ClassEntityModel.fromSnapshot(DocumentSnapshot document){
    
    final data = document.data() as Map<String, dynamic>;

    final classProfessorEntity = ClassProfessorEntityModel.fromMap(data['professorClassEntity']);

    return ClassEntityModel(
      classId: data['classId'],
      cep: data['cep'],
      city: data['city'],
      region: data['region'],
      state: data['state'],
      location: data['location'],
      unitName: data['unitName'],
      schedule: List.from(data['schedule'] ?? []),
      professorClassEntity: classProfessorEntity,
    );

  }


  @override
  ClassEntityModel copyWith({

    String? classId,
    String? cep,
    String? city,
    String? state,
    String? region,
    String? location,
    String? unitName,
    List<String>? schedule,
    ClassProfessorEntity? professorClassEntity,
    List<ClassMemberEntity>? members,

  }){

    return ClassEntityModel(
      classId: classId ?? this.classId,
      cep: cep ?? this.cep,
      city: city ?? this.city,
      region: region ?? this.region,
      state: state ?? this.state,
      location: location ?? this.location,
      unitName: unitName ?? this.unitName,
      schedule: schedule ?? this.schedule,
      professorClassEntity: professorClassEntity ?? this.professorClassEntity,
      members: members ?? this.members,
    );

  }


}