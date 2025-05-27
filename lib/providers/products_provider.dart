import 'dart:convert';
import 'package:balanced_foods/models/product.dart';
import 'package:balanced_foods/screens/modulo_pedidos/product_catalog_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductsProvider extends ChangeNotifier{
  bool isLoading = false;
  List<Product> products = [];
  final Map<int, ProductSelection> _selectionMap = {};
  
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

  final Map<int, Map<int, ProductSelection>> _customerSelections = {};

  void toggleSelection(Product product, {required bool isSelected, required int quantity}) {
    if (_currentCustomerId == null) return;

    final customerMap = _customerSelections.putIfAbsent(_currentCustomerId!, () => {});

    if (customerMap.containsKey(product.idProduct)) {
      final existing = customerMap[product.idProduct]!;
      existing.isSelected = isSelected;
      existing.quantity = quantity;
      existing.controller.text = quantity > 0 ? quantity.toString() : '';
    } else {
      final sel = ProductSelection(product: product);
      sel.isSelected = isSelected;
      sel.quantity = quantity;
      sel.controller.text = quantity > 0 ? quantity.toString() : '';
      customerMap[product.idProduct] = sel;
    }

    notifyListeners();
  }

  int? _currentCustomerId;

  void setCurrentCustomer(int customerId) {
    _currentCustomerId = customerId;
    _customerSelections.putIfAbsent(customerId, () => {});
    notifyListeners();
  }

  Map<int, ProductSelection> get selectionMap =>
      _customerSelections[_currentCustomerId] ?? {};

  List<ProductSelection> get selectedProducts =>
      selectionMap.values.where((s) => s.isSelected && s.quantity > 0).toList();

  void setSelectedProducts(List<ProductSelection> selections) {
    if (_currentCustomerId == null) return;

    final customerMap = <int, ProductSelection>{};
    for (var sel in selections) {
      customerMap[sel.product.idProduct] = sel;
    }
    _customerSelections[_currentCustomerId!] = customerMap;

    notifyListeners();
  }

  void clearSelections() {
    _customerSelections.clear();
    _currentCustomerId = null;
    notifyListeners();
  }
}