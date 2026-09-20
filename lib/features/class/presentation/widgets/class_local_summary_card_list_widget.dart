import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/summary_card_widget.dart';

class ClassLocalMetricSummaryCardListWidget extends StatelessWidget {
  const ClassLocalMetricSummaryCardListWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                  metricValue: "3",
                  metricDescription: "Turmas ativas",
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
                  metricValue: "42",
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