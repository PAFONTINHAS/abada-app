import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_member_entity.dart';

class ClassMembersListWidget extends StatelessWidget {
  const ClassMembersListWidget({super.key, required this.studentsList});

  final List<ClassMemberEntity> studentsList;
  @override
  Widget build(BuildContext context) {

    final double maxListSize = 500.0;

    final double currentListSize = studentsList.length * 80.0;

    final double listSize = (currentListSize > maxListSize) ? maxListSize : currentListSize;

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
      child: studentsList.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  "Nenhum aluno matriculado.",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          : SizedBox(
              height: listSize,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: studentsList.length,
                separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade200, indent: 72),
                itemBuilder: (context, index) {
                  final student = studentsList[index];

                  final String memberName =
                      (student.displaySensitiveData && student.name != null)
                      ? student.name!
                      : "Anônimo";

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
                      memberName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      'Corda ${student.belt}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: Colors.grey.shade400,
                    ),
                    onTap: () {},
                  );
                },
              ),
            ),
    );
  }
}
