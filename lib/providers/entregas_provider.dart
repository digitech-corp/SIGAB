import 'dart:convert';
import 'package:balanced_foods/models/entrega.dart';
import 'package:balanced_foods/models/order.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EntregasProvider extends ChangeNotifier{
  bool isLoading = false;
  List<Entrega> entregas= [];
  List<Entrega> entregaAnterior= [];
  List<Order> orders= [];

  Map<int, String> estadosPorOrder = {};
  
  Future<void> fetchEntregas(String token, String fechaInicio, String fechaFin, int? idTransportista) async {
    isLoading = true;
    notifyListeners();

    try {
      final entregasUrl = Uri.parse('https://adysabackend.facturador.es/ventas/getProgramaciones');
      final entregasResponse = await http.post(
        entregasUrl,
        headers: {'Authorization': 'Bearer $token'},
        body: jsonEncode({
          'fecha_inicio': fechaInicio,
          'fecha_fin': fechaFin,
          'id_transportista': idTransportista
        }),
      );

      if (entregasResponse.statusCode == 200) {
        final List<dynamic> entregasData = jsonDecode(entregasResponse.body);
        entregas = entregasData.map((item) => Entrega.fromJSON(item)).toList();

        for (final entrega in entregas) {
          if (entrega.idOrder != null) {
            await fetchEstadoEntrega(token, entrega.idOrder!);
          }
        }
      } else {
        print('Error: ${entregasResponse.statusCode}');
        entregas = [];
      }
    } catch (e) {
      print('Error al obtener entregas: $e');
      entregas = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchEstadoEntrega(String token, int idOrder) async {
    try {
      final url = Uri.parse(
        'https://adysabackend.facturador.es/ventas/getHistorialEstadoEntrega',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'id_venta': idOrder}),
      );

      if (response.statusCode != 200) {
        throw Exception('Error obteniendo estado entrega: ${response.statusCode}');
      }

      final entregasData = jsonDecode(response.body) as List<dynamic>;
      entregaAnterior = entregasData.map((json) => Entrega.fromJSON(json)).toList();
      final historial = entregasData.map((json) => Entrega.fromJSON(json)).toList();

      String ultimoEstado = '';
      if (historial.isNotEmpty) {
        ultimoEstado = historial.first.estado?.trim() ?? '';
      }

      estadosPorOrder[idOrder] = ultimoEstado;

      final index = entregas.indexWhere((e) => e.idOrder == idOrder);
      if (index != -1) {
        entregas[index] = entregas[index].copyWith(estado: ultimoEstado);
      }

    } catch (e) {
      print('Error al obtener estados entrega: $e');
      estadosPorOrder[idOrder] = '';
    } finally {
      notifyListeners();
    }
  }

  String getEstadoPorOrder(int idOrder) {
    return estadosPorOrder[idOrder] ?? 'Cargando...';
  }

  Future<bool> registerEntrega(String token, Entrega entrega) async {
    final url = Uri.parse('https://adysabackend.facturador.es/ventas/actualizarEntrega');
    try {
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode(entrega.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final index = entregas.indexWhere((e) => e.idOrder == entrega.idOrder);
        if (index != -1) {
          entregas[index] = entregas[index].copyWith(
            estado: entrega.estado ?? '',
          );
        }

        entregaAnterior.add(entrega);
        notifyListeners();

        return true;
      } else {
        print('Error al registrar: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}