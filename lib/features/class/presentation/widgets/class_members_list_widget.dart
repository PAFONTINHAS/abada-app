import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_member_entity.dart';

class ClassMembersListWidget extends StatelessWidget {
  const ClassMembersListWidget({
    super.key,
    required this.orderedStudents,
    required this.visibleStudentNameIds,
    this.onRemoveStudent,
  });

  final List<ClassMemberEntity> orderedStudents;
  final Set<String> visibleStudentNameIds;
  final Future<void> Function(ClassMemberEntity student)? onRemoveStudent;

  @override
  Widget build(BuildContext context) {
    const double maxListSize = 300.0;
    final currentListSize = orderedStudents.length * 80.0;
    final listSize = currentListSize > maxListSize
        ? maxListSize
        : currentListSize;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: orderedStudents.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  'Nenhum aluno matriculado.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          : SizedBox(
              height: listSize,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: orderedStudents.length,
                separatorBuilder: (context, index) =>
                    Divider(height: 1, color: Colors.grey.shade200, indent: 72),
                itemBuilder: (context, index) {
                  final student = orderedStudents[index];

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: ColorConstants.indigoColor.withOpacity(
                        0.1,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: ColorConstants.indigoColor,
                      ),
                    ),
                    title: Text(
                      _formattedMemberTitle(
                        student,
                        isNameVisible: visibleStudentNameIds.contains(
                          student.studentId,
                        ),
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      'CORDA ${student.belt.trim().toUpperCase()}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    trailing: onRemoveStudent == null
                        ? Icon(Icons.chevron_right, color: Colors.grey.shade400)
                        : IconButton(
                            tooltip: 'Remover aluno da turma',
                            icon: const Icon(Icons.person_remove_outlined),
                            color: Colors.red.shade700,
                            onPressed: () => onRemoveStudent!(student),
                          ),
                    onTap: onRemoveStudent == null
                        ? null
                        : () => onRemoveStudent!(student),
                  );
                },
              ),
            ),
    );
  }

  String _formattedMemberTitle(
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
