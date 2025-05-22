import 'dart:convert';
import 'package:balanced_foods/models/company.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CompaniesProvider extends ChangeNotifier{
  bool isLoading = false;
  List<Company> companies = [];
  
  Future<void> fetchCompanies() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.parse('http://10.0.2.2:12346/companies');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        companies = List<Company>.from(data['companies'].map((company) => Company.fromJSON(company)));
      } else {
        print('Error ${response.statusCode}');
        companies = [];
      }
    } catch (e) {
      print('Error: $e');
      companies = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<int> createCompany(Company company) async {
    final response = await http.post(Uri.parse('http://10.0.2.2:12346/companies'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(company.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Error al registrar empresa');
    }
    final data = jsonDecode(response.body);
    return data['idCompany'];
  }
}