
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Lineas extends StatefulWidget {
  final entregas;
  const Lineas ({super.key, required this.entregas});

  @override
  State<Lineas> createState() => _LineasState();
}

class _LineasState extends State<Lineas> {
  @override
  Widget build(BuildContext context) {
    final entregas = widget.entregas;
    final Map<int, int> entregadosPorDia = {};
    final Map<int, int> noEntregadosPorDia = {};

    for (var e in entregas) {
      DateTime fecha = e.fechaProgramacion;
      int dia = fecha.weekday - 1;

      if (e.idEstado == 239) {
        entregadosPorDia[dia] = (entregadosPorDia[dia] ?? 0) + 1;
      } else if (e.idEstado == 240) {
        noEntregadosPorDia[dia] = (noEntregadosPorDia[dia] ?? 0) + 1;
      }
    }

    final spotsEntregados = List.generate(7, (i) =>
      FlSpot(i.toDouble(), (entregadosPorDia[i] ?? 0).toDouble()));

    final spotsNoEntregados = List.generate(7, (i) =>
      FlSpot(i.toDouble(), (noEntregadosPorDia[i] ?? 0).toDouble()));

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Pedidos Entregados vs No Entregados por día",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 150,
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sab', 'Dom'][value.toInt()],
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12,
                              fontWeight: FontWeight.w400
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 50,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spotsEntregados,
                      isCurved: false,
                      color: Colors.green,
                      barWidth: 2,
                      dashArray: null,
                      belowBarData: BarAreaData(show: true, color: Colors.green.withValues()),
                    ),
                    LineChartBarData(
                      spots: spotsNoEntregados,
                      isCurved: false,
                      color: Colors.red,
                      barWidth: 2,
                      dashArray: [6, 4],
                      belowBarData: BarAreaData(show: true, color: Colors.red.withValues()),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) =>  Colors.black87,
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((spot) {
                          final int yValue = spot.y.toInt();
                          String label = '';

                          if (spot.barIndex == 0) {
                            label = '$yValue: Entregado${yValue == 1 ? '' : 's'}';
                          } else if (spot.barIndex == 1) {
                            label = '$yValue: No Entregado${yValue == 1 ? '' : 's'}';
                          }

                          return LineTooltipItem(
                            label,
                            TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}