import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      backgroundColor: const Color(0xFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- CARDS SUPERIORES ---
              Row(
                children: [
                  Expanded(
                    child: _buildKpiCard(
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
                    child: _buildKpiCard(
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
                    SizedBox(
                      height: 220,
                      child: const CordasBarChart(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para construir os Cards de KPI
  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required Color subtitleColor,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEFEFEF)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF7C7C8A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: subtitleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
        ],
      ),
    );
  }
}

// --- WIDGET DO GRÁFICO (FL_CHART) ---
class CordasBarChart extends StatelessWidget {
  const CordasBarChart({super.key});

  final List<Map<String, dynamic>> _data = const [
    {'label': 'Branca', 'value': 152.0, 'color': Color(0xFFE2E8F0)},
    {'label': 'Amarela', 'value': 128.0, 'color': Color(0xFFFFC107)},
    {'label': 'Laranja', 'value': 86.0, 'color': Color(0xFFFF7A00)},
    {'label': 'Verde', 'value': 72.0, 'color': Color(0xFF2EA44F)},
    {'label': 'Azul', 'value': 45.0, 'color': Color(0xFF3B82F6)},
    {'label': 'Roxa', 'value': 28.0, 'color': Color(0xFF8B5CF6)},
    {'label': 'Marrom', 'value': 14.0, 'color': Color(0xFF8B4513)},
    {'label': 'Preta', 'value': 7.0, 'color': Color(0xFF1E1E1E)},
  ];

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 180,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            left: BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
            bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
          ),
        ),
        titlesData: FlTitlesData(
          // Oculta eixos não utilizados
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          
          // Eixo Y (Valores na esquerda: 0, 60, 120, 180)
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 60,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),

          // Eixo X (Nomes das cordas)
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < _data.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _data[index]['label'],
                      style: const TextStyle(
                        color: Color(0xFF2D3142),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),

        // Barras e labels do topo
        barGroups: _data.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return BarChartGroupData(
            x: index,
            showingTooltipIndicators: [0], // Exibe o valor fixo acima da barra
            barRods: [
              BarChartRodData(
                toY: item['value'],
                color: item['color'],
                width: 28,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
            ],
          );
        }).toList(),

        // Estilização das pontuações/números acima de cada barra
        barTouchData: BarTouchData(
          enabled: false,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => Colors.transparent,
            tooltipPadding: EdgeInsets.zero,
            tooltipMargin: 6,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                rod.toY.toInt().toString(),
                const TextStyle(
                  color: Color(0xFF2D3142),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}