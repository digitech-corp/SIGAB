import 'dart:convert';
import 'package:balanced_foods/models/province.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class ProvincesProvider extends ChangeNotifier{
  bool isLoading = false;
  bool useLocalData = false;
  List<Province> provinces = [];
  
  Future<void> fetchProvinces() async {
    isLoading = true;
    notifyListeners();
    try {
      if (useLocalData) {
        final data = await loadJsonFromAssets('assets/datos/provinces.json');
        provinces = List<Province>.from(data['provinces'].map((province) => Province.fromJSON(province)));
      } else {
        final url = Uri.parse('http://10.0.2.2:12346/provinces');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          provinces = List<Province>.from(data['provinces'].map((province) => Province.fromJSON(province)));
        } else {
          print('Error: ${response.statusCode}');
          provinces = [];
        }
      }
    } catch (e) {
      print('Error: $e');
      provinces = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String getProvinceName(int idProvince) {
  return provinces
          .firstWhere(
            (p) => p.idProvince == idProvince,
            orElse: () => Province(idProvince: 0, province: '', idDepartment: 0),
          )
          .province;
  }
  // Método para obtener provincias por departamento para usarlo más adelante
  List<Province> getProvincesByDepartment(int idDepartment) {
    return provinces.where((p) => p.idDepartment == idDepartment).toList();
  }

  // CARGAR DATOS
  Future<Map<String, dynamic>> loadJsonFromAssets(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return json.decode(jsonString);
  }
}