import 'dart:typed_data';
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
  final pdf = pw.Document();

  final dateFormatted = order.dateCreated != null
      ? DateFormat('dd/MM/yyyy').format(order.dateCreated!)
      : 'Fecha no disponible';

  DateTime now = DateTime.now();
  String horaActual = DateFormat.Hm().format(now);
  String fechaActual = DateFormat('dd/MM/yyyy').format(now);

  final header = pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text('ALIMENTOS BALANCEADOS ADYSA', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
      pw.Text('RUC: 12345678910'),
      pw.Text('Dirección: Jr. Ejemplo 123 - Lima, Perú'),
      pw.Text('Fecha: $fechaActual'),
      pw.Text('Hora: $horaActual'),
      pw.Text('Factura N° ${order.idOrder}'),
    ],
  );

  final customerInfo = pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text('Cliente: ${customer.customerName}'),
      pw.Text('Empresa: $companyName'),
      pw.Text('Ubicación: ${order.deliveryLocation}'),
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
      pw.Text('Subtotal: S/ ${order.subtotal.toStringAsFixed(2)}'),
      pw.Text('IGV (18%): S/ ${order.igv.toStringAsFixed(2)}'),
      pw.Text('Total: S/ ${order.total.toStringAsFixed(2)}',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
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
            pw.Table.fromTextArray(data: productTableRows),
            pw.Divider(),
            totals,
            pw.SizedBox(height: 24),
            pw.Center(child: pw.Text('Gracias por su compra')),
          ],
        ),
      ),
    ),
  );

  return pdf.save();
}
