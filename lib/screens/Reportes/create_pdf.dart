import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:balanced_foods/models/order.dart';
import 'package:balanced_foods/models/product.dart';
import 'package:balanced_foods/models/customer.dart';

Future<Uint8List> generarPdfFacturaConDiseno({
  required Order order,
  required Customer customer,
  required String companyName,
  required List<Product> allProducts,
}) async {
  // Carga la fuente personalizada
  final ttf = pw.Font.ttf(await rootBundle.load('assets/fonts/Montserrat-Regular.ttf'));
  final pdf = pw.Document();

  DateTime now = DateTime.now();
  String horaActual = DateFormat.Hm().format(now);
  String fechaActual = DateFormat('dd/MM/yyyy').format(now);

  final header = pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        'ALIMENTOS BALANCEADOS ADYSA',
        style: pw.TextStyle(font: ttf, fontSize: 20, fontWeight: pw.FontWeight.bold),
      ),
      pw.Text('RUC: 12345678910', style: pw.TextStyle(font: ttf)),
      pw.Text('Dirección: Jr. Ejemplo 123 - Lima, Perú', style: pw.TextStyle(font: ttf)),
      pw.Text('Fecha: $fechaActual', style: pw.TextStyle(font: ttf)),
      pw.Text('Hora: $horaActual', style: pw.TextStyle(font: ttf)),
      pw.Text('Factura N° ${order.idOrder}', style: pw.TextStyle(font: ttf)),
    ],
  );

  final customerInfo = pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text('Cliente: ${customer.customerName}', style: pw.TextStyle(font: ttf)),
      pw.Text('Empresa: $companyName', style: pw.TextStyle(font: ttf)),
      pw.Text('Ubicación: ${order.deliveryLocation}', style: pw.TextStyle(font: ttf)),
    ],
  );

  final productTableRows = <List<String>>[
    ['Producto', 'Cantidad', 'Precio', 'Subtotal'],
    ...order.details.map((detail) {
      final product = allProducts.firstWhere(
        (p) => p.idProduct == detail.idProducto,
        orElse: () => Product(idProduct: 0, productName: '', productType: '', animalType: '', price: 0.0, state: false),
      );

      return [
        product.productName,
        'x${detail.quantity}',
        'S/ ${detail.unitPrice.toStringAsFixed(2)}',
        'S/ ${detail.partialPrice.toStringAsFixed(2)}',
      ];
    }),
  ];

  final totals = pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.end,
    children: [
      pw.Text('Subtotal: S/ ${order.subtotal.toStringAsFixed(2)}', style: pw.TextStyle(font: ttf)),
      pw.Text('IGV (18%): S/ ${order.igv.toStringAsFixed(2)}', style: pw.TextStyle(font: ttf)),
      pw.Text('Total: S/ ${order.total.toStringAsFixed(2)}',
          style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold)),
    ],
  );

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (_) => pw.Padding(
        padding: const pw.EdgeInsets.all(20),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            header,
            pw.SizedBox(height: 16),
            customerInfo,
            pw.Divider(),
            pw.Table.fromTextArray(
              data: productTableRows,
              cellStyle: pw.TextStyle(font: ttf),
              headerStyle: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold),
            ),
            pw.Divider(),
            totals,
            pw.SizedBox(height: 24),
            pw.Center(
              child: pw.Text('Gracias por su compra', style: pw.TextStyle(font: ttf)),
            ),
          ],
        ),
      ),
    ),
  );

  return pdf.save();
}
