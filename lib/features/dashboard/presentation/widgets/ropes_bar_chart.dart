import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RopesBarChart extends StatelessWidget {
  const RopesBarChart({super.key});

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
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),

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
                        fontSize: 10,
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
