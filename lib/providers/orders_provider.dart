import 'dart:convert';
import 'package:balanced_foods/models/order.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrdersProvider extends ChangeNotifier{
  bool isLoading = false;
  List<Order> orders = [];
  
  Future<void> fetchOrders() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.parse('http://10.0.2.2:12346/orders');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Datos obtenidos: $data');
        orders = List<Order>.from(data['orders'].map((order) => Order.fromJSON(order)));
        print('Total pedidos obtenidos: ${orders.length}');
      } else {
        print('Error ${response.statusCode}');
        orders = [];
      }
    } catch (e) {
      print('Error: $e');
      orders = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> registerOrder(Order order) async {
    final url = Uri.parse('http://10.0.2.2:12346/orders');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(order.toJson()),
      );
      
      if (response.statusCode == 201) {
        await fetchOrders();
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
}