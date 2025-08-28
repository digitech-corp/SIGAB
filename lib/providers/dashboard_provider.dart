import 'dart:convert';
import 'package:balanced_foods/models/order.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardProvider extends ChangeNotifier{
  bool isLoading = false;
  List<Order> orders = [];
  
  Future<void> fetchOrders(String token, String fechaFin, String fechaInicio, int? idPersonal) async {
    isLoading = true;
    notifyListeners();

    try {
      final urlDetalles = Uri.parse('https://adysabackend.facturador.es/ventas/getVentasConDetalles');
      final urlEmision = Uri.parse('https://adysabackend.facturador.es/ventas/getVentas');

      final body = {
        'fecha_fin': fechaFin,
        'fecha_inicio': fechaInicio,
        'id_personal': idPersonal,
      };

      final responseDetalles = await http.post(
        urlDetalles,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      final responseEmision = await http.post(
        urlEmision,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'fecha_fin': fechaFin,
          'fecha_inicio': fechaInicio,
        }),
      );

      if (responseDetalles.statusCode == 200 && responseEmision.statusCode == 200) {
        final dataDetalles = jsonDecode(responseDetalles.body) as List<dynamic>;
        final dataEmision = jsonDecode(responseEmision.body) as List<dynamic>;

        final Map<int, Map<String, dynamic>> infoOrders = {
          for (var order in dataEmision)
            order['id'] as int: {
              'fecha_emision': order['fecha_emision'],
              'nombre_tipo_pago': order['nombre_tipo_pago'],
              'id_tipo_pago': order['id_tipo_pago'],
            }
        };
        orders = await Future.wait(dataDetalles.map<Future<Order>>((json) async {
          final order = Order.fromJSON(json);
          final info = infoOrders[order.idOrder ?? 0];
          if (info != null) {
            final fechaEmisionStr = info['fecha_emision'] as String?;
            final nombreTipoPagoStr = info['nombre_tipo_pago'] as String?;
            final idTipoPagoStr = info['id_tipo_pago'] as int?;

            if (fechaEmisionStr != null) {
              order.fechaEmision = DateTime.tryParse(fechaEmisionStr); // si usas un campo separado
            }

            order.paymentMethod = nombreTipoPagoStr;
            order.idPaymentMethod = idTipoPagoStr;
          }
          if (order.idOrder != null) {
            final detalleResponse = await http.post(
              Uri.parse('https://adysabackend.facturador.es/ventas/getVentaCompletaID'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode({'id': order.idOrder}),
            );

            if (detalleResponse.statusCode == 200) {
              final detalleData = jsonDecode(detalleResponse.body);
              order.estadoFacturacion = detalleData['estado_facturacion'];
            } else {
              print('Error al obtener detalle de pedido ${order.idOrder}: ${detalleResponse.statusCode}');
            }
          }
          return order;
        }).toList());
      } else {
        print('Error en alguna de las respuestas: detalles(${responseDetalles.statusCode}), emisión(${responseEmision.statusCode})');
        orders = [];
      }
    } catch (e) {
      print('Error: $e');
      orders = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}