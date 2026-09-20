import 'package:sistema_abada_capoeira/features/class/domain/entities/class_member_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_professor_entity.dart';

class ClassEntity {

  const ClassEntity({
    required this.classId,
    required this.cep,
    required this.city,
    required this.region,
    required this.state,
    required this.location,
    required this.unitName,
    required this.schedule,
    required this.professor,
    this.members = const []
  }); 

  final String classId;
  final String cep;
  final String city;
  final String state;
  final String region;
  final String location;
  final String unitName;
  final List<String> schedule;
  final ClassProfessorEntity professor;
  final List<ClassMemberEntity> members;

  ClassEntity copyWith({

    String? classId,
    String? cep,
    String? city,
    String? state,
    String? region,
    String? location,
    String? unitName,
    List<String>? schedule,
    ClassProfessorEntity? professor,
    List<ClassMemberEntity>? members,

  }){

    return ClassEntity(
      classId: classId ?? this.classId,
      cep: cep ?? this.cep,
      city: city ?? this.city,
      region: region ?? this.region,
      state: state ?? this.state,
      location: location ?? this.location,
      unitName: unitName ?? this.unitName,
      schedule: schedule ?? this.schedule,
      professor: professor ?? this.professor,
      members: members ?? this.members,
    );

  }


}