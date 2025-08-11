import 'dart:convert';
import 'dart:typed_data';
import 'package:balanced_foods/models/customer.dart';
import 'package:balanced_foods/models/ubigeo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomersProvider extends ChangeNotifier{  
  bool isLoading = false;
  List<Customer> customers = [];
  Map<int, Uint8List> customerPhotos = {};
  Map<int, Ubigeo> customerUbigeos = {};
  
  Future<void> fetchCustomers(String token) async {
    isLoading = true;
    notifyListeners();
    try {
      final url = Uri.parse('https://adysabackend.facturador.es/clientes/getClientes');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        customers = data.map((customerJson) => Customer.fromJSON(customerJson)).toList();
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

  Future<Customer?> fetchCustomerById(String token, int idCustomer) async {
    try {
      final url = Uri.parse('https://adysabackend.facturador.es/clientes/getClientesById/$idCustomer/');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final customer = Customer.fromJSON(data[0]);
          return customer;
        }
      } else {
        print('Error ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  Future<void> fetchCustomerPhoto(String fileName, String token, int idCliente) async {
    final url = 'https://backend.adysanutricion.com/archivos/clientes/$fileName';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      customerPhotos[idCliente] = response.bodyBytes;
      notifyListeners();
    }
  }

  Future<void> registerCustomer(Customer customer, String token) async {
    final body = customer.toApiRequest();
    final response = await http.post(
      Uri.parse('https://adysabackend.facturador.es/clientes/createCliente'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode ==200){
      print("respuesta: ${response.body}");
      fetchCustomers(token);
    }

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Error al crear el cliente: ${response.body}');
    }
  }

  Future<void> updateCustomer(Map<String, dynamic> cuerpo, String token) async {
    final response = await http.post(
      Uri.parse('https://adysabackend.facturador.es/clientes/updateCliente'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(cuerpo),
    );
    if (response.statusCode ==200 ){
      fetchCustomers(token);
    }

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Error al crear el cliente: ${response.body}');
    }
  }
}