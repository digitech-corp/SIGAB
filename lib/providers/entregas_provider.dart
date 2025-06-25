import 'dart:convert';
import 'package:balanced_foods/models/entrega.dart';
import 'package:balanced_foods/providers/AppSettingsProvider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class EntregasProvider extends ChangeNotifier{
  final AppSettingsProvider settingsProvider;
  EntregasProvider({required this.settingsProvider});
  bool get useLocalData => settingsProvider.useLocalData;
  
  bool isLoading = false;
  List<Entrega> entregas= [];
  
  Future<void> fetchEntregas() async {
    isLoading = true; 
    notifyListeners();

    try {
      if (useLocalData) {
        final data = await loadJsonFromAssets('assets/datos/entregas.json');
        entregas = List<Entrega>.from(data['entregas'].map((entrega) => Entrega.fromJSON(entrega)));
      } else {
        final url = Uri.parse('http://10.0.2.2:12346/entregas');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          entregas = List<Entrega>.from(data['entregas'].map((entrega) => Entrega.fromJSON(entrega)));
        } else {
          print('Error ${response.statusCode}');
          entregas = [];
        }
      }
    } catch (e) {
      print('Error: $e');
      entregas = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> registerEntrega(Entrega entrega) async {
    if (useLocalData) {
      print('Modo de prueba: No se puede registrar un usuario en un archivo local.');
      return false;
    }
    final url = Uri.parse('http://10.0.2.2:12346/entregas');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(entrega.toJson()),
      );
      
      if (response.statusCode == 201) {
        await fetchEntregas();
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

  // CARGAR DATOS
  Future<Map<String, dynamic>> loadJsonFromAssets(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return json.decode(jsonString);
  }
}