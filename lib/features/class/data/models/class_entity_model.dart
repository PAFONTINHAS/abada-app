import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/schedule_entity.dart';
import 'package:sistema_abada_capoeira/features/class/data/models/schedule_entity_model.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_member_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_professor_entity.dart';
import 'package:sistema_abada_capoeira/features/class/data/models/class_professor_entity_model.dart';

class ClassEntityModel extends ClassEntity{

  const ClassEntityModel({
    super.members,
    required super.classId,
    required super.unitName,
    required super.schedule,
    required super.professor,
    required super.locationId,
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
      locationId: data['locationId'],
      unitName: data['unitName'],
      schedule: schedule,
      professor: classProfessorEntity,
      members: []
    );

  }

  factory ClassEntityModel.fromEntity(ClassEntity entity){
    return ClassEntityModel(
      classId: entity.classId,
      unitName: entity.unitName,
      schedule: entity.schedule,
      professor: entity.professor,
      locationId: entity.locationId,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'unitName': unitName,
      'locationId': locationId,
      'schedule': schedule.map((data) => data.toMap()).toList(),
      'professor': professor.toMap(),
    };
  }

  @override
  ClassEntityModel copyWith({
    String? classId,
    String? locationId,
    String? unitName,
    List<ScheduleEntity>? schedule,
    ClassProfessorEntity? professor,
    List<ClassMemberEntity>? members,

  }){

    return ClassEntityModel(
      classId: classId ?? this.classId,
      locationId: locationId ?? this.locationId,
      unitName: unitName ?? this.unitName,
      schedule: schedule ?? this.schedule,
      professor: professor ?? this.professor, 
      members: members ?? this.members,
    );

  }
}