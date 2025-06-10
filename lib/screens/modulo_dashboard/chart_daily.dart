import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesDonutChart extends StatelessWidget {
  final List<SalesData> data = [
    SalesData('Bikes', 94.6205, const Color.fromARGB(255, 93, 13, 158)),
    SalesData('Components', 11.7991, const Color.fromARGB(255, 253, 106, 155)),
    SalesData('Clothing', 2.1176, const Color.fromARGB(255, 135, 153, 255)),
  ];

  @override
  Widget build(BuildContext context) {
    double total = data.fold(0, (sum, item) => sum + item.sales);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SfCircularChart(
          margin: EdgeInsets.zero,
          legend: Legend(isVisible: false),
          annotations: [
            CircularChartAnnotation(
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$${total.toStringAsFixed(2)}M',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  Text('Total Sales', style: TextStyle(fontSize: 14)),
                ],
              ),
            )
          ],
          series: <CircularSeries>[
            DoughnutSeries<SalesData, String>(
              dataSource: data,
              xValueMapper: (SalesData d, _) => d.category,
              yValueMapper: (SalesData d, _) => d.sales,
              pointColorMapper: (SalesData d, _) => d.color,
              dataLabelMapper: (SalesData d, _) =>
                  '${d.category}\n\$${d.sales.toStringAsFixed(4)}M',
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.black,
                ),
                labelPosition: ChartDataLabelPosition.outside,
                connectorLineSettings: ConnectorLineSettings(
                  type: ConnectorType.curve,
                  length: '10%',
                ),
              ),
              radius: '80%',
              innerRadius: '80%',
            ),
          ],
        ),
      ),
    );
  }
}

class SalesData {
  final String category;
  final double sales;
  final Color color;

  SalesData(this.category, this.sales, this.color);
}