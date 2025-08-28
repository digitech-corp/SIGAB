import 'dart:convert';
import 'package:balanced_foods/models/tipoCliente.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TipoClienteProvider extends ChangeNotifier {
  bool isLoading = false;
  List<TipoCliente> tiposCliente = [];

  Future<void> fetchTipoCliente(String token) async {
      isLoading = true;
      notifyListeners();
      try {
        final url = Uri.parse('https://adysabackend.facturador.es/sistema/getTiposClientes');
        final response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          tiposCliente = data.map((tipoJson) => TipoCliente.fromJSON(tipoJson)).toList();
        } else {
          print('Error ${response.statusCode}');
          tiposCliente = [];
        }
      } catch (e) {
        print('Error: $e');
        tiposCliente = [];
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
}