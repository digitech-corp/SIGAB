import 'dart:convert';
import 'package:balanced_foods/models/tipoDocumento.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TipoDocumentoProvider extends ChangeNotifier {
  bool isLoading = false;
  List<TipoDocumento> tiposDocumento = [];

  Future<void> fetchTipoDocumento(String token) async {
      isLoading = true;
      notifyListeners();
      try {
        final url = Uri.parse('https://adysabackend.facturador.es/persona/getTiposDocumentos');
        final response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          tiposDocumento = data.map((tipoJson) => TipoDocumento.fromJSON(tipoJson)).toList();
        } else {
          print('Error ${response.statusCode}');
          tiposDocumento = [];
        }
      } catch (e) {
        print('Error: $e');
        tiposDocumento = [];
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }

  Future<Map<String, dynamic>> traerDatosPorDni(String token, String dni) async {
    final url = Uri.parse('https://adysabackend.facturador.es/reniec/getInfoDni');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'dni': dni}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final bool success = data['success'] == true;

        if (success) {
          final String nombre = data['result']['razon_social'] ?? '';
          return {
            'response': true,
            'nombre': nombre,
          };
        } else {
          return {
            'response': false,
            'mensaje': 'No se encontró información para este DNI'
          };
        }
      } else {
        return {
          'response': false,
          'mensaje': 'Error al procesar la solicitud.'
        };
      }
    } catch (e) {
      return {
        'response': false,
        'mensaje': 'Ocurrió un error. Intenta nuevamente.'
      };
    }
  }

  Future<Map<String, dynamic>> traerDatosPorRuc(String token, String ruc) async {
    final url = Uri.parse('https://adysabackend.facturador.es/sunat/getInfoRuc');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'ruc': ruc}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final bool success = data['success'] == true;
        print('Informacion: $data');

        if (success) {
          final String nombre = data['nombre'] ?? '';
          final String direccion = data['direccion'] ?? '';
          final String ubigeo = data['ubigeo'] ?? '';
          final String departamento = data['departamento'] ?? '';
          final String provincia = data['provincia'] ?? '';
          final String distrito = data['distrito'] ?? '';
          return {
            'response': true,
            'nombre': nombre,
            'direccion': direccion,
            'ubigeo': ubigeo,
            'departamento': departamento,
            'provincia': provincia,
            'distrito': distrito,
          };
        } else {
          return {
            'response': false,
            'mensaje': 'No se encontró información para este RUC'
          };
        }
      } else {
        return {
          'response': false,
          'mensaje': 'Error al procesar la solicitud.'
        };
      }
    } catch (e) {
      return {
        'response': false,
        'mensaje': 'Ocurrió un error. Intenta nuevamente.'
      };
    }
  }
}