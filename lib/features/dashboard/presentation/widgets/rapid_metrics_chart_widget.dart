import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/kpi_card_widget.dart';
import 'package:sistema_abada_capoeira/features/dashboard/presentation/widgets/ropes_bar_chart.dart';

class RapidMetricsChartWidget extends StatelessWidget {
  const RapidMetricsChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- CARDS SUPERIORES ---
        Row(
          children: [
            Expanded(
              child: KpiCardWidget(
                title: 'Novos membros',
                value: '45',
                subtitle: '+12% em relação ao mês anterior',
                subtitleColor: Colors.green,
                icon: Icons.person_add_outlined,
                iconColor: const Color(0xFF6C5CE7),
                iconBgColor: const Color(0xFFF0EDFF),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: KpiCardWidget(
                title: 'Crescimento',
                value: '8,6%',
                subtitle: 'Em relação ao mês anterior',
                subtitleColor: Colors.grey,
                icon: Icons.trending_up,
                iconColor: Colors.green,
                iconBgColor: const Color(0xFFE8F8EE),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // --- CARD DO GRÁFICO ---
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEFEFEF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Membros por corda',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(height: 220, child: const RopesBarChart()),
            ],
          ),
        ),
      ],
    );
  }
}
