import 'dart:convert';
import 'package:balanced_foods/models/department.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DepartmentsProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Department> departments = [];

  Future<void> fetchDepartments(String token) async {
    isLoading = true;
    notifyListeners();
    try {
      final url = Uri.parse('https://adysabackend.facturador.es/ubigeos/getDepartamentos');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        departments = data.map((item) => Department.fromJSON(item)).toList();
      } else {
        print('Error: ${response.statusCode}');
        departments = [];
      }
    } catch (e) {
      print('Error: $e');
      departments = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}