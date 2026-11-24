import 'package:sistema_abada_capoeira/core/utils/abada_belts.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_member_entity.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_metrics_entity.dart';

class GetClassMetricsUsecase {
  ClassMetricsEntity call(
    ClassEntity classEntity, {
    required String currentUserId,
  }) {
    final isClassProfessor =
        currentUserId == classEntity.professor.professorId;
    final visibleStudentNameIds = classEntity.members
        .where(
          (student) => isClassProfessor || student.displaySensitiveData,
        )
        .map((student) => student.studentId)
        .toSet();
    final beltOrder = {
      for (final belt in AbadaBelts.belts)
        belt.belt.trim().toUpperCase(): belt.number,
    };
    final orderedStudents = List<ClassMemberEntity>.from(classEntity.members)
      ..sort((first, second) {
        final firstBeltOrder =
            beltOrder[first.belt.trim().toUpperCase()] ?? -1;
        final secondBeltOrder =
            beltOrder[second.belt.trim().toUpperCase()] ?? -1;
        final beltComparison = secondBeltOrder.compareTo(firstBeltOrder);

        if (beltComparison != 0) return beltComparison;

        final firstTitle = _memberSortTitle(
          first,
          isNameVisible: visibleStudentNameIds.contains(first.studentId),
        );
        final secondTitle = _memberSortTitle(
          second,
          isNameVisible: visibleStudentNameIds.contains(second.studentId),
        );
        final titleComparison = firstTitle.toLowerCase().compareTo(
          secondTitle.toLowerCase(),
        );

        if (titleComparison != 0) return titleComparison;
        return first.studentId.compareTo(second.studentId);
      });

    return ClassMetricsEntity(
      totalStudents: classEntity.members.length,
      orderedStudentsByBelt: orderedStudents,
      visibleStudentNameIds: visibleStudentNameIds,
    );
  }

  String _memberSortTitle(
    ClassMemberEntity student, {
    required bool isNameVisible,
  }) {
    final visibleName = isNameVisible ? student.name?.trim() : null;
    final name = visibleName == null || visibleName.isEmpty
        ? 'Anônimo'
        : visibleName;
    final nickname = student.nickname?.trim();

    if (nickname == null || nickname.isEmpty) return name;
    return '$name ($nickname)';
  }
}
