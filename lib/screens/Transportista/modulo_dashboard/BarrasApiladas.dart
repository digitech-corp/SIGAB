import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarrasApiladas extends StatefulWidget {
  final entregas;
  const BarrasApiladas ({super.key, required this.entregas});

  @override
  State<BarrasApiladas> createState() => _BarrasApiladasState();
}

class _BarrasApiladasState extends State<BarrasApiladas> {
  // final List<String> etapas = [
  //   'Entregado',
  //   'No Entregado'
  // ];

  // final List<double> valores = [30, 75, 45, 20];

  // final List<Color> colores = [
  //   Color(0xFF4A90E2),
  //   Color(0xFFF5A623),
  //   Color(0xFF7ED321),
  //   Color(0xFFD0021B),
  // ];

  // int? selectedIndex;
  // double calculateInterval() {
  //   final maxValue = valores.reduce((a, b) => a > b ? a : b);

  //   double rawInterval = maxValue / 5;

  //   double roundedInterval = (rawInterval / 10).round() * 10;

  //   if (roundedInterval == 0) {
  //     roundedInterval = 10;
  //   }

  //   return roundedInterval.toDouble();
  // }


  @override
  Widget build(BuildContext context) {
    final entregas = widget.entregas;
    final int idRutaSur = 234;
    final int idRutaNorte = 232;
    final int idRutaCentro = 233;
    final int idRutaEste = 235;
    final int idRutaOeste = 236;
    final int idEntregado = 239;
    final int idNoEntregado = 240;

    final surEntregas = entregas.where((e) =>
        e.idRuta == idRutaSur && e.idEstado == idEntregado).toList();
    final surNoEntregas = entregas.where((e) =>
        e.idRuta == idRutaSur && e.idEstado == idNoEntregado).toList();

    final norteEntregas = entregas.where((e) =>
        e.idRuta == idRutaNorte && e.idEstado == idEntregado).toList();
    final norteNoEntregas = entregas.where((e) =>
        e.idRuta == idRutaNorte && e.idEstado == idNoEntregado).toList();

    final centroEntregas = entregas.where((e) =>
        e.idRuta == idRutaCentro && e.idEstado == idEntregado).toList();
    final centroNoEntregas = entregas.where((e) =>
        e.idRuta == idRutaCentro && e.idEstado == idNoEntregado).toList();

    final esteEntregas = entregas.where((e) =>
        e.idRuta == idRutaEste && e.idEstado == idEntregado).toList();
    final esteNoEntregas = entregas.where((e) =>
        e.idRuta == idRutaEste && e.idEstado == idNoEntregado).toList();

    final oesteEntregas = entregas.where((e) =>
        e.idRuta == idRutaOeste && e.idEstado == idEntregado).toList();
    final oesteNoEntregas = entregas.where((e) =>
        e.idRuta == idRutaOeste && e.idEstado == idNoEntregado).toList();

    // CANTIDADES
    final double surEntregaLenght = (surEntregas.length).toDouble();
    final double surNoEntregaLenght = (surNoEntregas.length).toDouble();
    final double norteEntregaLenght = (norteEntregas.length).toDouble();
    final double norteNoEntregaLenght = (norteNoEntregas.length).toDouble();
    final double centroEntregaLenght = (centroEntregas.length).toDouble();
    final double centroNoEntregaLenght = (centroNoEntregas.length).toDouble();
    final double esteEntregaLenght = (esteEntregas.length).toDouble();
    final double esteNoEntregaLenght = (esteNoEntregas.length).toDouble();
    final double oesteEntregaLenght = (oesteEntregas.length).toDouble();
    final double oesteNoEntregaLenght = (oesteNoEntregas.length).toDouble();


    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Pedidos Entregados vs No Entregados por zona",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 150,
              child: BarChart(
                BarChartData(
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(toY: surEntregaLenght, color: Colors.green),
                        BarChartRodData(toY: surNoEntregaLenght, color: Colors.red),
                      ],
                      barsSpace: 2,
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(toY: norteEntregaLenght, color: Colors.green),
                        BarChartRodData(toY: norteNoEntregaLenght, color: Colors.red),
                      ],
                      barsSpace: 2,
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(toY: centroEntregaLenght, color: Colors.green),
                        BarChartRodData(toY: centroNoEntregaLenght, color: Colors.red),
                      ],
                      barsSpace: 2,
                    ),
                    BarChartGroupData(
                      x: 3,
                      barRods: [
                        BarChartRodData(toY: esteEntregaLenght, color: Colors.green),
                        BarChartRodData(toY: esteNoEntregaLenght, color: Colors.red),
                      ],
                      barsSpace: 2,
                    ),
                    BarChartGroupData(
                      x: 4,
                      barRods: [
                        BarChartRodData(toY: oesteEntregaLenght, color: Colors.green),
                        BarChartRodData(toY: oesteNoEntregaLenght, color: Colors.red),
                      ],
                      barsSpace: 2,
                    ),
                  ],
                  titlesData: FlTitlesData(
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            ['Sur', 'Norte', 'Centro', 'Este', 'Oeste'][value.toInt()],
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
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