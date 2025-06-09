import 'dart:convert';
import 'package:balanced_foods/models/customer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class CustomersProvider extends ChangeNotifier{
  bool isLoading = false;
  bool useLocalData = false;
  List<Customer> customers = [];
  
  Future<void> fetchCustomers() async {
    isLoading = true;
    notifyListeners();
    try {
      if (useLocalData) {
        final data = await loadJsonFromAssets('assets/datos/customers.json');
        customers = List<Customer>.from(data['customers'].map((customer) => Customer.fromJSON(customer)));
      } else {
        final url = Uri.parse('http://10.0.2.2:12346/customers');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          customers = List<Customer>.from(data['customers'].map((customer) => Customer.fromJSON(customer)));
        } else {
          print('Error ${response.statusCode}');
          customers = [];
        }
      }
    } catch (e) {
      print('Error: $e');
      customers = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> registerCustomer(Customer customer) async {
    if (useLocalData) {
      print('Modo de prueba: No se puede registrar un usuario en un archivo local.');
      return false;
    }

    final url = Uri.parse('http://10.0.2.2:12346/customers');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(customer.toJson()),
      );
      
      if (response.statusCode == 201) {
        await fetchCustomers();
        return true;
        
      } else {
        print('Error al registrar: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
  
  // CARGAR DATOS
  Future<Map<String, dynamic>> loadJsonFromAssets(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return json.decode(jsonString);
  }
}