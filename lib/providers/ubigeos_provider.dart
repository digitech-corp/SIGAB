import 'dart:convert';
import 'package:balanced_foods/models/ubigeo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UbigeosProvider extends ChangeNotifier{  
  bool isLoading = false;
  List<Ubigeo> ubigeos = [];
  
  Future<void> fetchUbigeos(String token) async {
    isLoading = true;
    notifyListeners();
    try {
      final url = Uri.parse('https://adysabackend.facturador.es/ubigeos/getUbigeos');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        ubigeos = data.map((ubigeoJson) => Ubigeo.fromJSON(ubigeoJson)).toList();
      } else {
        print('Error ${response.statusCode}');
        ubigeos = [];
      }
    } catch (e) {
      print('Error: $e');
      ubigeos = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}