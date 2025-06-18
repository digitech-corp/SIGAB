import 'package:balanced_foods/models/order.dart';
import 'package:balanced_foods/models/product.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class MonthlySalesData {
  final String month;
  final double total;

  MonthlySalesData(this.month, this.total);
}

class MonthlyLineChart extends StatelessWidget {
  final Map<String, List<MonthlySalesData>> dataByAnimalType;

  const MonthlyLineChart({super.key, required this.dataByAnimalType});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: 'Ventas mensuales por tipo de animal', textStyle: AppTextStyles.base),
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
          xValueMapper: (MonthlySalesData sales, _) => sales.month,
          yValueMapper: (MonthlySalesData sales, _) => sales.total,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            textStyle: AppTextStyles.base
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
    if (order.dateCreated == null) continue;
    final month = order.dateCreated!.month;

    for (var detail in order.details) {
      final product = products.firstWhere((p) => p.idProduct == detail.idProducto);
      
      final animalType = product.animalType;

      grouped.putIfAbsent(animalType, () => {});
      grouped[animalType]!.update(
        month,
        (existing) => existing + detail.partialPrice,
        ifAbsent: () => detail.partialPrice,
      );
    }
  }

  // Arma los datos por animalType
  final Map<String, List<MonthlySalesData>> chartData = {};
  for (var entry in grouped.entries) {
    final animalType = entry.key;
    final salesByMonth = entry.value;
    chartData[animalType] = [];
    for (int i = 1; i <= now.month; i++) {
      final total = salesByMonth[i] ?? 0;
      final monthName = DateFormat.MMM('es').format(DateTime(now.year, i));
      chartData[animalType]!.add(MonthlySalesData(monthName, total));
    }
  }
  return chartData;
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
