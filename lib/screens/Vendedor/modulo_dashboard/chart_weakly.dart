import 'package:balanced_foods/models/order.dart';
import 'package:balanced_foods/models/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesData {
  final String animalType;
  final double totalSales;
  final Color color;

  SalesData(this.animalType, this.totalSales, this.color);
}

class WeeklyBarChart extends StatelessWidget {
  final List<SalesData> data;

  const WeeklyBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: 'Ventas de la semana por tipo de animal', textStyle: AppTextStyles.base),
      primaryXAxis: CategoryAxis(
        labelStyle: AppTextStyles.base
      ),
      primaryYAxis: NumericAxis(
        numberFormat: NumberFormat.currency(symbol: 'S/.', decimalDigits: 2),
        labelStyle: AppTextStyles.number
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<SalesData, String>>[
        ColumnSeries<SalesData, String>(
          dataSource: data,
          xValueMapper: (SalesData d, _) => d.animalType,
          yValueMapper: (SalesData d, _) => d.totalSales,
          pointColorMapper: (SalesData d, _) => d.color,
          dataLabelSettings: DataLabelSettings(
            margin: EdgeInsets.only(bottom: 10),
            isVisible: true,
            textStyle: AppTextStyles.data
          ),
        )
      ],
    );
  }
}

List<SalesData> buildSalesDataByAnimalTypeWeekly(List<Order> orders, List<Product> products) {
  final Map<String, double> salesByAnimalType = {};

  for (var order in orders) {
    for (var detail in order.details!) {
      final product = products.firstWhere(
        (p) => p.idProduct == detail.idProduct,
        orElse: () => Product(
            idProduct: 0,
            productName: '',
            animalType: 'Desconocido',
            productType: '',
            price: 0,
            state: 0,
            unidadMedida: ''
          ),
      );
      final animalType = product.animalType;

      salesByAnimalType.update(
        animalType,
        (existing) => existing + detail.importeNeto!,
        ifAbsent: () => detail.importeNeto!,
      );
    }
  }

  final colors = [
    Colors.indigo,
    Colors.green,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.blueGrey,
  ];
  int colorIndex = 0;

  return salesByAnimalType.entries.map((entry) {
    final color = colors[colorIndex % colors.length];
    colorIndex++;
    return SalesData(entry.key, entry.value, color);
  }).toList();
}

class AppTextStyles {
  static const base = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    fontSize: 10,
    color: AppColors.gris
  );
  static final number = base.copyWith(fontWeight: FontWeight.w300);
  static final data = base.copyWith(fontWeight: FontWeight.w500);
}

class AppColors {
  static const gris = Color(0xFF333333);
}