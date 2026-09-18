import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/core/router/route_controller.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_entity.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/pages/student_class_page.dart';
import 'package:sistema_abada_capoeira/features/profile/presentation/controllers/profile_controller.dart';

class ClassCardWidget extends StatelessWidget {
  const ClassCardWidget({
    super.key,
    required this.classEntity
  });

  final ClassEntity classEntity;
  // final String className;
  // final String hour;
  // final String location;
  // final String professor;
  // final int studentQuantity;
  // final VoidCallback onPressed;


  @override
  Widget build(BuildContext context) {
    
    final classLocation = "${classEntity.location}, ${classEntity.city} - ${classEntity.state}, ${classEntity.cep}";
    String classSchedule = "";

    classEntity.schedule.map((schedule) => classSchedule += "$schedule\n");

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Material(
        color: ColorConstants.whiteColor,
        borderRadius: BorderRadius.circular(12),
        elevation: 2, // Sombra suave substituindo a borda
        shadowColor: const Color.fromARGB(253, 0, 0, 0),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => RouteController.redirectToStudentClassPage(context: context, classEntity: classEntity),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Ícone com proporções circulares corrigidas
                Container(
                  width: 56,
                  height: 56,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorConstants.indigoColor,
                  ),
                  child: Image.asset(
                    "assets/images/white_abada_player_icon.png",
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(width: 14),

                // Dados da Turma
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        classEntity.unitName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        classLocation,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700, // Contraste hierárquico
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        classSchedule,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Badge de Alunos e Seta
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: ColorConstants.indigoColor.withOpacity(0.12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${classEntity.members.length}",
                            style: TextStyle(
                              color: ColorConstants.indigoColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Alunos',
                            style: TextStyle(
                              color: ColorConstants.indigoColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 28,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}