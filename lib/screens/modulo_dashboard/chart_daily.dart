import 'package:balanced_foods/models/order.dart';
import 'package:balanced_foods/models/product.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesDonutChart extends StatelessWidget {
  final List<SalesData> data;

  const SalesDonutChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    double total = data.fold(0, (sum, item) => sum + item.totalSales);
    return SfCircularChart(
      annotations: [
        CircularChartAnnotation(
          widget: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'S/.${total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.indigo),
              ),
              const Text('Total Ventas', style: TextStyle(fontFamily: 'Montserrat', fontSize: 12)),
            ],
          ),
        )
      ],
      series: <CircularSeries>[
        DoughnutSeries<SalesData, String>(
          dataSource: data,
          xValueMapper: (SalesData d, _) => d.animalType,
          yValueMapper: (SalesData d, _) => d.totalSales,
          pointColorMapper: (SalesData d, _) => d.color,
          dataLabelMapper: (SalesData d, _) =>
              '${d.animalType}\n\S/.${d.totalSales.toStringAsFixed(2)}',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            connectorLineSettings: ConnectorLineSettings(type: ConnectorType.curve, length: '10%'),
            textStyle: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w500, fontSize: 10),
          ),
          radius: '80%',
          innerRadius: '75%',
        ),
      ],
    );
  }
}

List<SalesData> buildSalesDataByAnimalType(List<Order> orders, List<Product> products) {
  Map<String, double> salesByAnimalType = {};

  for (var order in orders) {
    for (var detail in order.details) {
      final product = products.firstWhere((p) => p.idProduct == detail.idProducto, orElse: () => Product(idProduct: 0, productName: '', animalType: 'Desconocido', productType: '', price: 0, state: false));
      final animalType = product.animalType;

      salesByAnimalType.update(
        animalType,
        (existing) => existing + detail.partialPrice,
        ifAbsent: () => detail.partialPrice,
      );
    }
  }

  // Asignar colores únicos por tipo (puedes personalizar más)
  final List<Color> colors = [
    Colors.green,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.blueGrey,
    Colors.indigo,
  ];

  int colorIndex = 0;

  return salesByAnimalType.entries.map((entry) {
    final color = colors[colorIndex % colors.length];
    colorIndex++;
    return SalesData(entry.key, entry.value, color);
  }).toList();
}

class SalesData {
  final String animalType;
  final double totalSales;
  final Color color;

  SalesData(this.animalType, this.totalSales, this.color);
}