import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/schedule_entity.dart';
import 'package:sistema_abada_capoeira/features/class/data/models/schedule_entity_model.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_member_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_professor_entity.dart';
import 'package:sistema_abada_capoeira/features/class/data/models/class_professor_entity_model.dart';

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
    required super.professor,
    super.members
  }); 


  factory ClassEntityModel.fromSnapshot(DocumentSnapshot document){
    
    final data = document.data() as Map<String, dynamic>;

    final classProfessorEntity = ClassProfessorEntityModel.fromMap(data['professor']);

    final List<dynamic> scheduleList = data['schedule'] as List<dynamic>;

    final List<Map<String, dynamic>> typedList = List<Map<String, dynamic>>.from(scheduleList);

    final List<ScheduleEntity> schedule = typedList
        .map((data) => ScheduleEntityModel.fromSnapshot(data))
        .toList();

    return ClassEntityModel(
      classId: document.id,
      cep: data['cep'],
      city: data['city'],
      region: data['region'],
      state: data['state'],
      location: data['location'],
      unitName: data['unitName'],
      schedule: schedule,
      professor: classProfessorEntity,
      members: []
    );

  }

  factory ClassEntityModel.fromEntity(ClassEntity entity){
    return ClassEntityModel(
      classId: entity.classId,
      cep: entity.cep,
      city: entity.city,
      region: entity.region,
      state: entity.state,
      location: entity.location,
      unitName: entity.unitName,
      schedule: entity.schedule,
      professor: entity.professor,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'cep': cep,
      'city': city,
      'region': state,
      'state': region,
      'location': location,
      'unitName': unitName,
      'schedule': schedule.map((data) => data.toMap()).toList(),
      'professor': professor.toMap(),
    };
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
    List<ScheduleEntity>? schedule,
    ClassProfessorEntity? professor,
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
      professor: professor ?? this.professor, 
      members: members ?? this.members,
    );

  }


}