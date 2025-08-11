import 'dart:convert';
import 'package:balanced_foods/models/province.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProvincesProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Province> provinces = [];

  Future<void> fetchProvincesByDepartment(String departament, String token) async {
    isLoading = true;
    notifyListeners();
    try {
      final url = Uri.parse('https://adysabackend.facturador.es/ubigeos/getProvinciasByIdDepartamento/$departament');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        provinces = data.map((item) => Province.fromJSON(item)).toList();
      } else {
        print('Error: ${response.statusCode}');
        provinces = [];
      }
    } catch (e) {
      print('Error: $e');
      provinces = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}