import 'dart:typed_data';
import 'package:balanced_foods/models/customer.dart';
import 'package:balanced_foods/models/order.dart';
import 'package:balanced_foods/models/product.dart';
import 'package:balanced_foods/providers/companies_provider.dart';
import 'package:balanced_foods/providers/customers_provider.dart';
import 'package:balanced_foods/providers/orders_provider.dart';
import 'package:balanced_foods/providers/products_provider.dart';
import 'package:balanced_foods/screens/Reportes/create_pdf.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InvoiceScreen extends StatelessWidget {
  final int idOrder;

  const InvoiceScreen({super.key, required this.idOrder});

  @override
  Widget build(BuildContext context) {
    print('ID DE PEDIDO: ${idOrder}');
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final customersProvider = Provider.of<CustomersProvider>(context);
    final companiesProvider = Provider.of<CompaniesProvider>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);

    // Buscar la orden por su ID
    final order = ordersProvider.orders
        .where((o) => o.idOrder == idOrder)
        .toList()
        .lastOrNull;

    // Si no se encuentra la orden, mostrar mensaje
    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Factura')),
        body: const Center(child: Text('No se encontró una orden con este ID')),
      );
    }

    // Buscar al cliente relacionado a la orden
    final customer = customersProvider.customers
        .where((c) => c.idCustomer == order.idCustomer)
        .toList()
        .lastOrNull;

    // Obtener nombre de la compañía
    final company = customer != null
        ? companiesProvider.getCompanyNameById(customer.idCompany)
        : 'Compañía no encontrada';

    // Obtener el primer producto del detalle
    final firstDetail = order.details.isNotEmpty ? order.details.first : null;
    final product = firstDetail != null
        ? productsProvider.products
            .where((p) => p.idProduct == firstDetail.idProducto)
            .toList()
            .lastOrNull
        : null;

    // Verificaciones
    if (customer == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Factura')),
        body: const Center(child: Text('No se encontró el cliente para la orden')),
      );
    }

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Factura')),
        body: const Center(child: Text('No se encontró el producto de la orden')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Factura'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              final pdfBytes = await generarPdfFacturaConDiseno(
                order: order,
                customer: customer,
                companyName: company,
                allProducts: productsProvider.products,
              );

              await guardarPdfConFileSaver(
                pdfBytes,
                'factura_${order.idOrder}.pdf',
                context,
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildHeader(context, order),
            const SizedBox(height: 16),
            _buildCustomerInfo(customer, company, order),
            const Divider(),
            _buildProductTable(order, product),
            const Divider(),
            _buildTotals(order),
            const SizedBox(height: 24),
            const Text('Gracias por su compra', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Order order) {
    DateTime now = DateTime.now();
    String horaActual = DateFormat.Hm().format(now);
    String fechaActual = DateFormat('dd/MM/yyyy').format(now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ALIMENTOS BALANCEADOS ADYSA', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const Text('RUC: 12345678910'),
        const Text('Dirección: Jr. Ejemplo 123 - Lima, Perú'),
        //Text('Fecha: ${order.dateCreated != null ? DateFormat('dd/MM/yyyy').format(order.dateCreated!) : 'Fecha no disponible'}'),
        Text('Fecha: $fechaActual'),
        Text('Hora: $horaActual'),
        Text('Factura N° ${order.idOrder}'),
      ],
    );
  }

  Widget _buildCustomerInfo(Customer customer, String company, Order order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cliente: ${customer.customerName}'),
        Text('Empresa: ${company}'),
        Text('Ubicación: ${order.deliveryLocation}'),
      ],
    );
  }

  Widget _buildProductTable(Order order, Product product) {
    return Column(
      children: order.details.map((detail) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Expanded(flex: 4, child: Text(product.productName)),
              Expanded(flex: 2, child: Text('x${detail.quantity}')),
              Expanded(flex: 2, child: Text('S/ ${detail.unitPrice.toStringAsFixed(2)}')),
              Expanded(flex: 2, child: Text('S/ ${detail.partialPrice.toStringAsFixed(2)}')),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTotals(Order order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('Subtotal: S/ ${order.subtotal.toStringAsFixed(2)}'),
        Text('IGV (18%): S/ ${order.igv.toStringAsFixed(2)}'),
        Text('Total: S/ ${order.total.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Future<void> guardarPdfConFileSaver(Uint8List pdfBytes, String fileName, BuildContext context) async {
    try {
      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: pdfBytes,
        ext: 'pdf',
        mimeType: MimeType.pdf,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Factura guardada correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el archivo: $e')),
      );
    }
  }
}
