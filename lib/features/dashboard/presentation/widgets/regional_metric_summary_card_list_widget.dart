import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/summary_card_widget.dart';

class RegionalMetricSummaryCardListWidget extends StatelessWidget {
  const RegionalMetricSummaryCardListWidget({super.key});

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
                  metricIcon: Icons.person_outline,
                  iconColor: Color.fromRGBO(31, 24, 171, 5),
                  metricValue: "532",
                  metricDescription: "Membros na região",
                  backgroundIconColor: Color.fromRGBO(231, 227, 250, 100),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: isSmallScreen ? 0 : 1,
              child: SizedBox(
                width: isSmallScreen ? 110 : null,
                child: SummaryCardWidget(
                  metricIcon: Icons.check,
                  iconColor: Color.fromRGBO(31, 24, 171, 5),
                  metricValue: "27",
                  metricDescription: "Turmas ativas na região",
                  backgroundIconColor: Color.fromRGBO(221, 244, 227, 100),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: isSmallScreen ? 0 : 1,
              child: SizedBox(
                width: isSmallScreen ? 110 : null,
                child: SummaryCardWidget(
                  metricIcon: Icons.calendar_month_outlined,
                  iconColor: Color.fromRGBO(237, 153, 37, 100),
                  metricValue: "12",
                  metricDescription: "Eventos próximos",
                  backgroundIconColor: Color.fromRGBO(255, 240, 203, 100),
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
