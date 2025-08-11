import 'dart:convert';
import 'package:balanced_foods/models/district.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DistrictsProvider extends ChangeNotifier{
  bool isLoading = false;
  List<District> districts = [];
  
  Future<void> fetchDistrictsByProvince(String province, String token) async {
    isLoading = true;
    notifyListeners();
    try {
      final url = Uri.parse('https://adysabackend.facturador.es/ubigeos/getDistritosByIdProvincia/$province');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        districts = data.map((item) => District.fromJSON(item)).toList();
      } else {
        print('Error: ${response.statusCode}');
        districts = [];
      }
    } catch (e) {
      print('Error: $e');
      districts = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}