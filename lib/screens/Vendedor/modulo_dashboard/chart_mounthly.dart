import 'package:balanced_foods/models/order.dart';
import 'package:balanced_foods/models/product.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class MonthlyLineChart extends StatelessWidget {
  final Map<String, List<MonthlySalesData>> dataByAnimalType;

  const MonthlyLineChart({super.key, required this.dataByAnimalType});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: 'Ventas del mes por tipo de animal', textStyle: AppTextStyles.base),
      primaryXAxis: CategoryAxis(
        labelStyle: AppTextStyles.base
      ),
      primaryYAxis: NumericAxis(
        numberFormat: NumberFormat.currency(symbol: 'S/.', decimalDigits: 2),
        labelStyle: AppTextStyles.number
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        orientation: LegendItemOrientation.horizontal, 
        overflowMode: LegendItemOverflowMode.wrap,
        textStyle: AppTextStyles.Leyend
      ),
      series: dataByAnimalType.entries.map((entry) {
        return LineSeries<MonthlySalesData, String>(
          name: entry.key,
          dataSource: entry.value,
          xValueMapper: (MonthlySalesData sales, _) => sales.weekLabel,
          yValueMapper: (MonthlySalesData sales, _) => sales.total,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: AppTextStyles.Leyend
          ),
        );
      }).toList(),
    );
  }
}

Future<Map<String, List<MonthlySalesData>>> buildSalesDataByAnimalTypeMonthly(
    List<Order> orders, List<Product> products) async {
  final now = DateTime.now();
  await initializeDateFormatting('es', null);

  final Map<String, Map<int, double>> grouped = {};

  for (var order in orders) {
    if (order.fechaEmision == null) continue;

    final date = order.fechaEmision!;
    if (date.month != now.month || date.year != now.year) continue;

    final day = date.day;

    final weekNumber = ((day - 1) ~/ 7) + 1;

    for (var detail in order.details ?? []) {
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

      if (product.idProduct == 0) continue;

      final animalType = product.animalType;
      final importe = detail.importeNeto ?? 0;

      grouped.putIfAbsent(animalType, () => {});
      grouped[animalType]!.update(
        weekNumber,
        (existing) => existing + importe,
        ifAbsent: () => importe,
      );
    }
  }

  final Map<String, List<MonthlySalesData>> chartData = {};
  for (var entry in grouped.entries) {
    final animalType = entry.key;
    final salesByWeek = entry.value;

    chartData[animalType] = [];
    for (int i = 1; i <= 5; i++) {
      final total = salesByWeek[i] ?? 0;
      final weekLabel = 'Semana $i';
      chartData[animalType]!.add(MonthlySalesData(weekLabel, total));
    }
  }
  return chartData;
}

class MonthlySalesData {
  final String weekLabel;
  final double total;

  MonthlySalesData(this.weekLabel, this.total);
}

class AppTextStyles {
  static const base = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    fontSize: 10,
    color: AppColors.gris
  );
  static final number = base.copyWith(fontWeight: FontWeight.w300);
  static final Leyend = base.copyWith(fontWeight: FontWeight.w300, fontSize: 9);
}

class AppColors {
  static const gris = Color(0xFF333333);
}
