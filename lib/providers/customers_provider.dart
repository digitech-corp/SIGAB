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
    final customersUrl = Uri.parse('http://10.0.2.2:12346/customers');
    try {
      final customersResponse = await http.get(customersUrl);
      if (customersResponse.statusCode == 200) {
        final customersData = jsonDecode(customersResponse.body);
        customers = List<Customer>.from(customersData['customers'].map((customer) => Customer.fromJSON(customer)));
      } else {
        print('Error ${customersResponse.statusCode}');
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