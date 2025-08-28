import 'package:balanced_foods/models/order.dart';
import 'package:balanced_foods/models/product.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesDonutChart extends StatefulWidget {
  final List<SalesData> data;

  const SalesDonutChart({super.key, required this.data});

  @override
  State<SalesDonutChart> createState() => _SalesDonutChartState();
}

class _SalesDonutChartState extends State<SalesDonutChart> {
  @override
  Widget build(BuildContext context) {
    double total = widget.data.fold(0, (sum, item) => sum + item.totalSales);
    return SfCircularChart(
      annotations: [
        CircularChartAnnotation(
          widget: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('S/.${total.toStringAsFixed(2)}', style: AppTextStyles.total),
              Text('Total Ventas', style: AppTextStyles.base),
              Text('de hoy', style: AppTextStyles.base),
            ],
          ),
        )
      ],
      series: <CircularSeries>[
        DoughnutSeries<SalesData, String>(
          dataSource: widget.data,
          xValueMapper: (SalesData d, _) => d.animalType,
          yValueMapper: (SalesData d, _) => d.totalSales,
          pointColorMapper: (SalesData d, _) => d.color,
          dataLabelMapper: (SalesData d, _) =>
              '${d.animalType}\n\S/.${d.totalSales.toStringAsFixed(2)}',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            connectorLineSettings: ConnectorLineSettings(type: ConnectorType.curve, length: '10%'),
            textStyle: AppTextStyles.base,
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
    for (var detail in order.details!) {
      final product = products.firstWhere((p) => p.idProduct == detail.idProduct, orElse: () => Product(idProduct: 0, productName: '', animalType: 'Desconocido', productType: '', price: 0, state: 0, unidadMedida: ""));
      final animalType = product.animalType;

      salesByAnimalType.update(
        animalType,
        (existing) => existing + detail.importeNeto!,
        ifAbsent: () => detail.importeNeto!,
      );
    }
  }

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

class AppTextStyles {
  static const base = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    fontSize: 10, 
    color: AppColors.gris
  );
  static final total = base.copyWith(fontSize: 16, color: Colors.indigo);
}

class AppColors {
  static const gris = Color(0xFF333333);
}