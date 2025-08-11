import 'package:balanced_foods/models/product.dart';

class ProductSelection {
  final Product product;
  final int quantity;

  double? initialPrice;

  ProductSelection({required this.product, required this.quantity, this.initialPrice});
}