import 'dart:convert';
import 'package:balanced_foods/models/district.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DistrictsProvider extends ChangeNotifier{
  bool isLoading = false;
  List<District> districts = [];
  
  Future<void> fetchDistricts() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.parse('http://10.0.2.2:12346/districts');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        districts = List<District>.from(data['districts'].map((district) => District.fromJSON(district)));
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

  String getDistrictName(int idDistrict) {
    return districts
            .firstWhere(
              (d) => d.idDistrict == idDistrict,
              orElse: () => District(idDistrict: 0, district: '', idProvince: 0),
            )
            .district;
  }
}