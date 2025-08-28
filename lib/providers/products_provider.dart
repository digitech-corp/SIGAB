import 'dart:convert';
import 'package:balanced_foods/models/product.dart';
import 'package:balanced_foods/providers/orders_provider.dart';
import 'package:balanced_foods/screens/Vendedor/modulo_pedidos/product_catalog_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductsProvider extends ChangeNotifier{
  bool isLoading = false;
  List<Product> products = [];

  Future<void> fetchProducts(String token) async {
    isLoading = true;
    notifyListeners();
    try {
      final url = Uri.parse('https://adysabackend.facturador.es/articulos/getArticulosTodo');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        products = data.map((productJson) => Product.fromJSON(productJson)).toList();
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
  
  void toggleSelection(Product product, {required bool isSelected, required double quantity, bool shouldUpdateController = false}) {
    if (_currentCustomerId == null) return;

    final customerMap = _customerSelections.putIfAbsent(_currentCustomerId!, () => {});

    if (customerMap.containsKey(product.idProduct)) {
      final existing = customerMap[product.idProduct]!;
      existing.isSelected = isSelected;
      existing.quantity = quantity;
      if (shouldUpdateController) {
        existing.controller.text = quantity > 0 ? quantity.toString() : '';
      }
    } else {
      final sel = ProductSelection(product: product);
      sel.isSelected = isSelected;
      sel.quantity = quantity;
      if (shouldUpdateController) {
        sel.controller.text = quantity > 0 ? quantity.toString() : '';
      }
      customerMap[product.idProduct] = sel;
    }

    notifyListeners();
  }

  int? _currentCustomerId;
  void setCurrentCustomer(int customerId) {
    _currentCustomerId = customerId;
    final customerMap = _customerSelections.putIfAbsent(customerId, () => {});

    for (final product in products) {
      if (!customerMap.containsKey(product.idProduct)) {
        double precioInicial;
        if (product.igvType == 14) {
          precioInicial = (product.price * 1.18).roundToDouble();
        } else {
          precioInicial = product.price.roundToDouble();
        }

        customerMap[product.idProduct] = ProductSelection(
          product: product,
          initialPrice: precioInicial,
          currentPrice: precioInicial,
        );
      }
    }
  }

  Map<int, ProductSelection> get selectionMap =>
      _customerSelections[_currentCustomerId] ?? {};

  List<ProductSelection> get selectedProducts =>
      selectionMap.values.where((s) => s.isSelected && s.quantity > 0).toList();

  List<ProductSelection> get allSelections =>
      _customerSelections[_currentCustomerId] != null
          ? _customerSelections[_currentCustomerId]!.values.toList()
          : [];

  Map<int, List<Map<String, dynamic>>> _priceHistory = {};
  
  Future<void> loadPriceHistory(int customerId, OrdersProvider ordersProvider) async {
    _priceHistory = ordersProvider.getPriceHistoryForCustomer(customerId);
  }

   bool hasPriceHistoryForProduct(int idProduct) {
    return _priceHistory.containsKey(idProduct);
  }

  List<Map<String, dynamic>> getPriceHistory(int productId) {
    return _priceHistory[productId] ?? [];
  }

  void setSelectionsForCustomer(int customerId, List<ProductSelection> selections) {
    final customerMap = _customerSelections.putIfAbsent(customerId, () => {});
    for (final sel in selections) {
      customerMap[sel.product.idProduct] = sel;
    }
    _currentCustomerId = customerId;
    notifyListeners();
  }
  
  void updatePrice(int productId, double newPrice, {bool notify = false}) {
    if (_currentCustomerId == null) return;

    final selectionMap = _customerSelections[_currentCustomerId];
    if (selectionMap != null && selectionMap.containsKey(productId)) {
      final selection = selectionMap[productId]!;
      selection.currentPrice = newPrice;
      if (notify) notifyListeners();
    }
  }

  void clearSelections() {
    for (var customerMap in _customerSelections.values) {
      for (var selection in customerMap.values) {
        selection.isSelected = false;
        selection.quantity = 0;
        selection.currentPrice = null;
        selection.controller.text = '';
      }
    }
    _customerSelections.clear();
    _currentCustomerId = null;
    notifyListeners();
  }
}