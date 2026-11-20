import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_abada_capoeira/features/class/presentation/controllers/class_controller.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/summary_card_widget.dart';

class ClassLocalMetricSummaryCardListWidget extends StatelessWidget {
  const ClassLocalMetricSummaryCardListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ClassController>();

    int totalStudents = 0;

    for(final classEntity in controller.lecturedClasses){

      totalStudents += classEntity.members.length;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Se a tela for muito estreita (menos de 340px), permite rolar horizontalmente
        final bool isSmallScreen = constraints.maxWidth < 340;

        Widget content = Row(
          children: [
            Expanded(
              flex: isSmallScreen ? 0 : 1,
              child: SizedBox(
                width: isSmallScreen ? 110 : null,
                child: SummaryCardWidget(
                  metricIcon: Icons.group_outlined,
                  iconColor: const Color(0xFF1F18AB),
                  metricValue: "${controller.lecturedClasses.length}",
                  metricDescription: "Turma(s) ativa(s)",
                  backgroundIconColor: const Color(0xFFE7E3FA),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: isSmallScreen ? 0 : 1,
              child: SizedBox(
                width: isSmallScreen ? 110 : null,
                child: SummaryCardWidget(
                  metricIcon: Icons.school,
                  iconColor: const Color.fromRGBO(31, 24, 171, 1),
                  metricValue: "$totalStudents",
                  metricDescription: "Alunos matriculados",
                  backgroundIconColor: const Color(0xFFE7E3FA),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: isSmallScreen ? 0 : 1,
              child: SizedBox(
                width: isSmallScreen ? 110 : null,
                child: SummaryCardWidget(
                  metricIcon: Icons.school,
                  iconColor: const Color(0xFFED9925),
                  metricValue: "12",
                  metricDescription: "Alunos Graduados",
                  backgroundIconColor: const Color(0xFFFFF0CB),
                ),
              ),
            ),
          ],
        );

        if (isSmallScreen) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: content,
          );
        }

        return IntrinsicHeight(child: content);
      },
    );
  }
}