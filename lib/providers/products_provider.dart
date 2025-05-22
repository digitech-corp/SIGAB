import 'dart:convert';
import 'package:balanced_foods/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductsProvider extends ChangeNotifier{
  bool isLoading = false;
  List<Product> products = [];
  
  Future<void> fetchProducts() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.parse('http://10.0.2.2:12346/products');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        products = List<Product>.from(data['products'].map((product) => Product.fromJSON(product)));
      } else {
        print('Error ${response.statusCode}');
        products = [];
      }
    } catch (e) {
      print('Error: $e');
      products = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}