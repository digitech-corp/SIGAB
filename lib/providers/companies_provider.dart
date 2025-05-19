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
    final companiesUrl = Uri.parse('http://10.0.2.2:12346/companies');
    try {
      final companiesResponse = await http.get(companiesUrl);
      if (companiesResponse.statusCode == 200) {
        final companiesData = jsonDecode(companiesResponse.body);
        companies = List<Company>.from(companiesData['companies'].map((company) => Company.fromJSON(company)));
      } else {
        print('Error ${companiesResponse.statusCode}');
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
}