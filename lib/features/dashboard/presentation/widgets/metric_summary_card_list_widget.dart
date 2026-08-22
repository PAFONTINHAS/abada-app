import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/metric_summary_card_widget.dart';

class MetricSummaryCardListWidget extends StatelessWidget {
  const MetricSummaryCardListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        MetricSummaryCardWidget(
          metricIcon: Icons.person_outline,
          iconColor: Color.fromRGBO(31, 24, 171, 5),
          metricValue: "532",
          metricDescription: "Membros na região",
          backgroundIconColor: Color.fromRGBO(231, 227, 250, 100),
        ),

        MetricSummaryCardWidget(
          metricIcon: Icons.check,
          iconColor: Color.fromRGBO(31, 24, 171, 5),
          metricValue: "27",
          metricDescription: "Turmas ativas na região",
          backgroundIconColor: Color.fromRGBO(221, 244, 227, 100),
        ),

        MetricSummaryCardWidget(
          metricIcon: Icons.calendar_month_outlined,
          iconColor: Color.fromRGBO(237, 153, 37, 100),
          metricValue: "12",
          metricDescription: "Eventos próximos",
          backgroundIconColor: Color.fromRGBO(255, 240, 203, 100),
        ),
      ],
    );
  }
}
