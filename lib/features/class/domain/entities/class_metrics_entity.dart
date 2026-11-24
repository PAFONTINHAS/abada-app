import 'package:sistema_abada_capoeira/features/class/domain/entities/class_member_entity.dart';

class ClassMetricsEntity {
  ClassMetricsEntity({
    required this.totalStudents,
    required List<ClassMemberEntity> orderedStudentsByBelt,
    required Set<String> visibleStudentNameIds,
  }) : orderedStudentsByBelt = List.unmodifiable(orderedStudentsByBelt),
       visibleStudentNameIds = Set.unmodifiable(visibleStudentNameIds);

  final int totalStudents;
  final List<ClassMemberEntity> orderedStudentsByBelt;
  final Set<String> visibleStudentNameIds;
}
