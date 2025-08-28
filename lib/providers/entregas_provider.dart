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
    isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse('https://adysabackend.facturador.es/ventas/getHistorialEstadoEntrega');
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode({'id_venta': idOrder}),
      );

      if (response.statusCode != 200) {
        throw Exception('print:Error obteniendo estado entrega: ${response.statusCode}');
      }

      final List<dynamic> entregasData = jsonDecode(response.body);
      entregaAnterior = entregasData.map((json) => Entrega.fromJSON(json)).toList();
      List<Entrega> historialEstados = entregaAnterior;

      if (historialEstados.isNotEmpty) {
        final ultimoEstado = historialEstados.first.estado?.trim() ?? '';
        estadosPorOrder[idOrder] = ultimoEstado;
      } else {
        estadosPorOrder[idOrder] = '';
      }

    } catch (e) {
      print('print:Error al obtener estados entrega: $e');
      estadosPorOrder[idOrder] = '';
    } finally {
      isLoading = false;
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
      
      if (response.statusCode == 201) {
        // await fetchEntregas(token, fechaInicio, fechaFin);
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