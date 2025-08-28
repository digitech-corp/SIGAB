import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SegmentsLineChartFL extends StatelessWidget {
  const SegmentsLineChartFL({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Entregas de Productos por Zona",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 100,
              child:LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  lineBarsData: [
                    // Serie 1 - Azul
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 5),
                        FlSpot(1, 15),
                        FlSpot(2, 25),
                        FlSpot(3, 75),
                        FlSpot(4, 100),
                        FlSpot(5, 90),
                        FlSpot(6, 75),
                      ],
                      isCurved: false,
                      color: Colors.blue,
                      barWidth: 2,
                      dashArray: null,
                      belowBarData: BarAreaData(show: true, color: Colors.blue.withValues()),
                    ),
                    // Serie 2 - Roja con líneas punteadas
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 2),
                        FlSpot(1, 5),
                        FlSpot(2, 10),
                        FlSpot(3, 22),
                        FlSpot(4, 40),
                        FlSpot(5, 10),
                        FlSpot(6, 12),
                      ],
                      isCurved: false,
                      color: Colors.red,
                      barWidth: 2,
                      dashArray: [6, 4], // Patrón de línea punteada
                      belowBarData: BarAreaData(show: true, color: Colors.red.withValues()),
                    ),
                    // Serie 3 - Verde con línea más gruesa
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 5),
                        FlSpot(1, 15),
                        FlSpot(2, 25),
                        FlSpot(3, 75),
                        FlSpot(4, 100),
                        FlSpot(5, 90),
                        FlSpot(6, 75),
                      ],
                      isCurved: false,
                      color: Colors.green,
                      barWidth: 4,
                      dashArray: null,
                      belowBarData: BarAreaData(show: true, color: Colors.green.withValues()),
                    ),
                  ],
                ),
              )
            )
          ]
        )
      )
    );
  }
}