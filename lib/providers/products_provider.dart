import 'dart:convert';
import 'package:balanced_foods/models/product.dart';
import 'package:balanced_foods/providers/AppSettingsProvider.dart';
import 'package:balanced_foods/providers/orders_provider.dart';
import 'package:balanced_foods/screens/modulo_pedidos/product_catalog_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class ProductsProvider extends ChangeNotifier{
  final AppSettingsProvider settingsProvider;
  ProductsProvider({required this.settingsProvider});
  bool get useLocalData => settingsProvider.useLocalData;
  
  bool isLoading = false;
  List<Product> products = [];

  Future<void> fetchProducts() async {
    isLoading = true;
    notifyListeners();
    try {
      if (useLocalData) {
        final data = await loadJsonFromAssets('assets/datos/products.json');
        products = List<Product>.from(data['products'].map((product) => Product.fromJSON(product)));
      } else {
        final url = Uri.parse('http://10.0.2.2:12346/products');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          products = List<Product>.from(data['products'].map((product) => Product.fromJSON(product)));
        } else {
          print('Error ${response.statusCode}');
          products = [];
        }
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

  List<ProductSelection> get allSelections =>
      _customerSelections[_currentCustomerId] != null
          ? _customerSelections[_currentCustomerId]!.values.toList()
          : [];

  void setSelectedProducts(List<ProductSelection> selections) {
    if (_currentCustomerId == null) return;

    final customerMap = <int, ProductSelection>{};
    for (var sel in selections) {
      customerMap[sel.product.idProduct] = sel;
    }
    _customerSelections[_currentCustomerId!] = customerMap;

    notifyListeners();
  }

  late Map<int, List<Map<String, dynamic>>> _priceHistory;
  
  Future<void> loadPriceHistory(int customerId, OrdersProvider ordersProvider) async {
    _priceHistory = ordersProvider.getPriceHistoryForCustomer(customerId);
  }

  List<Map<String, dynamic>> getPriceHistory(int productId) {
    return _priceHistory[productId] ?? [];
  }

  void updatePrice(int productId, double newPrice) {
    if (_currentCustomerId == null) return;

    final selectionMap = _customerSelections[_currentCustomerId];
    if (selectionMap != null && selectionMap.containsKey(productId)) {
      selectionMap[productId]!.product.price = newPrice;
      notifyListeners();
    }
  }
  
  void clearSelections() {
    _customerSelections.clear();
    _currentCustomerId = null;
    notifyListeners();
  }

  // CARGAR DATOS
  Future<Map<String, dynamic>> loadJsonFromAssets(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return json.decode(jsonString);
  }
}