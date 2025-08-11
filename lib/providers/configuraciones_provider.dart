import 'dart:convert';
import 'package:balanced_foods/models/opcionCatalogo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OpcionCatalogoProvider extends ChangeNotifier{
  bool isLoading = false;
  List<OpcionCatalogo> documentosVenta = [];
  List<OpcionCatalogo> tipoPago = [];
  
  Future<void> fetchOpcionesVenta(String token) async {
    isLoading = true;
    notifyListeners();
    try {
      final url = Uri.parse('https://adysabackend.facturador.es/sistema/getConfiguraciones');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List<dynamic> document = json['documentos_venta'];
        final List<dynamic> pagos = json['tipo_pago'];
        documentosVenta = document.map((item) => OpcionCatalogo.fromJSON(item)).toList();
        tipoPago = pagos.map((item) => OpcionCatalogo.fromJSON(item)).toList();
      } else {
        print('Error: ${response.statusCode}');
        documentosVenta = [];
      }
    } catch (e) {
      print('Error: $e');
      documentosVenta = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}