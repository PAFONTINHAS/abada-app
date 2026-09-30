import 'package:sistema_abada_capoeira/features/class/domain/entities/class_member_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_professor_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/schedule_entity.dart';

class ClassEntity {

  const ClassEntity({
    required this.classId,
    required this.locationId,
    required this.unitName,
    required this.schedule,
    required this.professor,
    this.members = const []
  }); 

  final String classId;
  final String locationId;
  final String unitName;
  final List<ScheduleEntity> schedule;
  final ClassProfessorEntity professor;
  final List<ClassMemberEntity> members;

  ClassEntity copyWith({

    String? classId,
    String? locationId,
    String? unitName,
    List<ScheduleEntity>? schedule,
    ClassProfessorEntity? professor,
    List<ClassMemberEntity>? members,

  }){

    return ClassEntity(
      classId: classId ?? this.classId,
      locationId: locationId ?? this.locationId,
      unitName: unitName ?? this.unitName,
      schedule: List<ScheduleEntity>.from(schedule ?? this.schedule),
      professor: professor ?? this.professor,
      members: members ?? this.members,
    );

  }

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'locationId': locationId,
      'unitName': unitName,
      'schedule': schedule.map((data) => data.toMap()).toList(),
      'professor': professor.toMap(),
      'members': members,
    };
  }


}