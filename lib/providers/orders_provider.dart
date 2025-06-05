import 'dart:convert';
import 'package:balanced_foods/models/order.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class OrdersProvider extends ChangeNotifier{
  bool isLoading = false;
  bool useLocalData = true;
  List<Order> orders = [];
  
  Future<void> fetchOrders() async {
    isLoading = true;
    notifyListeners();
    try {
      if (useLocalData) {
        final data = await loadJsonFromAssets('assets/datos/orders.json');
        orders = List<Order>.from(data['orders'].map((order) => Order.fromJSON(order)));
      } else {
        final url = Uri.parse('http://10.0.2.2:12346/orders');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          orders = List<Order>.from(data['orders'].map((order) => Order.fromJSON(order)));
        } else {
          print('Error ${response.statusCode}');
          orders = [];
        }
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

  List<Order> getOrdersByCustomer(int customerId) {
    return orders.where((order) => order.idCustomer == customerId).toList();
  }

  Map<int, List<Map<String, dynamic>>> getPriceHistoryForCustomer(int customerId) {
    final Map<int, List<Map<String, dynamic>>> priceHistory = {};

    for (var order in orders.where((o) => o.idCustomer == customerId)) {
      for (var detail in order.details) {
        priceHistory.putIfAbsent(detail.idProducto, () => []);
        priceHistory[detail.idProducto]!.add({
          'unitPrice': detail.unitPrice,
          'dateCreated': order.dateCreated,
        });
      }
    }

    return priceHistory;
  }

  // CARGAR DATOS
  Future<Map<String, dynamic>> loadJsonFromAssets(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return json.decode(jsonString);
  }

}