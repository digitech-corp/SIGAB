import 'dart:convert';
import 'package:balanced_foods/models/district.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class DistrictsProvider extends ChangeNotifier{
  bool isLoading = false;
  bool useLocalData = true;
  List<District> districts = [];
  
  Future<void> fetchDistricts() async {
    isLoading = true;
    notifyListeners();
    try {
      if (useLocalData) {
        final data = await loadJsonFromAssets('assets/datos/districts.json');
        districts = List<District>.from(data['districts'].map((district) => District.fromJSON(district)));
      } else {
        final url = Uri.parse('http://10.0.2.2:12346/districts');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          districts = List<District>.from(data['districts'].map((district) => District.fromJSON(district)));
        } else {
          print('Error: ${response.statusCode}');
          districts = [];
        }
      }
    } catch (e) {
      print('Error: $e');
      districts = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String getDistrictName(int idDistrict) {
    return districts
            .firstWhere(
              (d) => d.idDistrict == idDistrict,
              orElse: () => District(idDistrict: 0, district: '', idProvince: 0),
            )
            .district;
  }

  // CARGAR DATOS
  Future<Map<String, dynamic>> loadJsonFromAssets(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return json.decode(jsonString);
  }
}