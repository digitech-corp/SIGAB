import 'dart:convert';
import 'package:balanced_foods/models/customer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomersProvider extends ChangeNotifier{
  bool isLoading = false;
  List<Customer> customers = [];
  
  Future<void> fetchCustomers() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.parse('http://10.0.2.2:12346/customers');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        customers = List<Customer>.from(data['customers'].map((customer) => Customer.fromJSON(customer)));
      } else {
        print('Error ${response.statusCode}');
        customers = [];
      }
    } catch (e) {
      print('Error: $e');
      customers = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}