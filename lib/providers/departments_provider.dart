import 'dart:convert';
import 'package:balanced_foods/models/department.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DepartmentsProvider extends ChangeNotifier{
  bool isLoading = false;
  List<Department> departments = [];

  int? selectedDepartmentId;
  int? selectedProvinceId;
  
  Future<void> fetchDepartments() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.parse('http://10.0.2.2:12346/departments');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        departments = List<Department>.from(data['departments'].map((department) => Department.fromJSON(department)));
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

  String getDepartmentName(int idDepartment) {
    return departments
            .firstWhere(
              (d) => d.idDepartment == idDepartment,
              orElse: () => Department(idDepartment: 0, department: 'Desconocido'),
            )
            .department;
  }
}