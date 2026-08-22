import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/metric_summary_card_widget.dart';

class CoordenatorDashboardPage extends StatelessWidget {
  const CoordenatorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Olá, \${apelido}!'),
        backgroundColor: Colors.white,
      ), body: Column(
        children: [
          
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 10),
            child: Row(

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
                
                // MetricSummaryCardWidget(
                //   metricIcon: Icons.person_add_alt,
                //   iconColor: Color.fromRGBO(217, 13, 55, 100),
                //   metricValue: "8",
                //   metricDescription: "Solicitações pendentes",
                //   backgroundIconColor: Color.fromRGBO(255, 221, 221, 100),
                // ),

                MetricSummaryCardWidget(
                  metricIcon: Icons.calendar_month_outlined,
                  iconColor: Color.fromRGBO(237, 153, 37, 100),
                  metricValue: "12",
                  metricDescription: "Eventos próximos",
                  backgroundIconColor: Color.fromRGBO(255, 240, 203, 100),
                ),
                
            
                
              ],
            )
          ),
        ],
      ),
    );
  }
}