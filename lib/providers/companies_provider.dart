import 'dart:convert';
import 'package:balanced_foods/models/company.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class CompaniesProvider extends ChangeNotifier{
  bool isLoading = false;
  bool useLocalData = true;
  List<Company> companies = [];
  
  Future<void> fetchCompanies() async {
    isLoading = true;
    notifyListeners();
    try {
      if (useLocalData) {
        final data = await loadJsonFromAssets('assets/datos/companies.json');
        companies = List<Company>.from(data['companies'].map((company) => Company.fromJSON(company)));
      } else {
        final url = Uri.parse('http://10.0.2.2:12346/companies');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          companies = List<Company>.from(data['companies'].map((company) => Company.fromJSON(company)));
        } else {
          print('Error ${response.statusCode}');
          companies = [];
        }
      }
    } catch (e) {
      print('Error: $e');
      companies = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String getCompanyNameById(int id) {
    return companies.firstWhere((c) => c.idCompany == id, orElse: () => Company(idCompany: 0, companyRUC: '', companyName: 'Desconocido', companyAddress: '', companyWeb: '')).companyName;
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

  // CARGAR DATOS
  Future<Map<String, dynamic>> loadJsonFromAssets(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return json.decode(jsonString);
  }
}