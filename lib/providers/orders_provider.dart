import 'dart:convert';
import 'package:balanced_foods/models/cuota.dart';
import 'package:balanced_foods/models/customer.dart';
import 'package:balanced_foods/models/order.dart';
import 'package:balanced_foods/models/orderDetail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrdersProvider2 extends ChangeNotifier{
  bool isLoading = false;
  List<Order> orders = [];
  List<Order> pedidosClienteCompletos = [];

  Order? _order;
  List<OrderDetail> _detalles = [];
  Customer? _cliente;

  Order? get order => _order;
  List<OrderDetail> get detalles => _detalles;
  Customer? get cliente => _cliente;
  
  Future<void> fetchOrders(String token, String fechaFin, String fechaInicio, int? idPersonal) async {
    isLoading = true;
    notifyListeners();

    try {
      final urlDetalles = Uri.parse('https://adysabackend.facturador.es/ventas/getVentasConDetalles');
      final urlEmision = Uri.parse('https://adysabackend.facturador.es/ventas/getVentas');

      final body = {
        'fecha_fin': fechaFin,
        'fecha_inicio': fechaInicio,
        'id_personal': idPersonal == null || idPersonal == 0 ? "" : idPersonal.toString(),
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

  Future<void> fetchPedidosClienteCompletos(String token, int idCliente) async {
    isLoading = true;
    notifyListeners();

    try {
      final clienteResponse = await http.get(
        Uri.parse('https://adysabackend.facturador.es/clientes/getClientesById/$idCliente/1'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (clienteResponse.statusCode != 200) {
        throw Exception('Error cargando datos del cliente');
      }

      final clienteData = jsonDecode(clienteResponse.body);
      final pedidosData = clienteData[0]['pedidos'] as List<dynamic>;

      List<Order> pedidosConDetalles = [];

      for (final pedidoJson in pedidosData) {
        final pedidoId = pedidoJson['id'];
        final Order order = Order.fromJSON(pedidoJson);
        order.idCustomer = idCliente;
        try {
          final detallesResponse = await http.post(
            Uri.parse('https://adysabackend.facturador.es/ventas/getVentaCompletaID'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'id': pedidoId}),
          );

          if (detallesResponse.statusCode == 200) {
            final body = detallesResponse.body.trim();
            if (body.startsWith('{') || body.startsWith('[')) {
              final detallesJson = jsonDecode(body);
              if (detallesJson['cabeza'] != null && detallesJson['cabeza'].isNotEmpty) {
                final cabeza = detallesJson['cabeza'][0];
                order.estadoFacturacion = cabeza['estado_facturacion'];
              }
              if (detallesJson['detalles'] != null) {                
                order.details = (detallesJson['detalles'] as List)
                  .map((detailJson) {
                    final detail = OrderDetail.fromJSON(detailJson);
                    return detail;
                  }).toList();
              } else {
                order.details = [];
                print('⚠️ No se encontraron detalles.');
              }
              if (detallesJson['cuotas'] != null && detallesJson['cuotas'].isNotEmpty) {
                order.cuotas = (detallesJson['cuotas'] as List)
                    .map((cuotaJson) => Cuota.fromJson(cuotaJson))
                    .toList();
              } else {
                order.cuotas = [];
              }
            } else {
              order.estadoFacturacion = null;
            }
          } else {
            print('Error HTTP ${detallesResponse.statusCode} para pedido $pedidoId');
            order.details = [];
          }
        } catch (e) {
          print('Error al parsear datos de pedido $pedidoId: $e');
          order.details = [];
        } 
        pedidosConDetalles.add(order);
      }
      pedidosClienteCompletos = pedidosConDetalles;
      notifyListeners();
    } catch (e) {
      pedidosClienteCompletos = [];
      print('Error fetchPedidosClienteCompletos: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Map<int, List<Map<String, dynamic>>> getPriceHistoryForCustomer(int idCustomer) {
    final Map<int, List<Map<String, dynamic>>> priceHistory = {};
    for (var order in pedidosClienteCompletos.where((o) => o.idCustomer == idCustomer)) {
      final date = order.fechaEmision;
      final comprobante = order.numComprobante;
      for (var detail in order.details ?? []) {
        final productId = detail.idProduct;
        if (productId == null) continue;

        priceHistory.putIfAbsent(productId, () => []);
        priceHistory[productId]!.add({
          'unitPrice': detail.unitPrice,
          'comprobante': comprobante,
          'date': date,
        });
      }
    }
    return priceHistory;
  }  

  Future<void> fetchCreditoOrders(String token, String fechaInicio, String fechaFin) async {
    isLoading = true;
    notifyListeners();
    try {
      final url = Uri.parse('https://adysabackend.facturador.es/cobranzas/getCobranzas');

      final body = {
        'condicion': '1',
        'fecha_inicio': fechaInicio,
        'fecha_fin': fechaFin,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      print('Enviando body: $body');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        print('Pedidos por creditos: $data');
        orders = data.map<Order>((json) {
          final order = Order.fromJSON(json);
          return order;
        }).toList();
      } else {
        print('Error en alguna de las respuestas: detalles(${response.statusCode})');
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

  Future<void> registerOrder(Order order, String token) async {
    final response = await http.post(
      Uri.parse('https://adysabackend.facturador.es/ventas/createVenta'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(order.toJson()),
    );

    if (response.statusCode ==200){
      print("respuesta: ${response.body}");
    }

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Error al crear el pedido: ${response.body}');
    }
  }
}