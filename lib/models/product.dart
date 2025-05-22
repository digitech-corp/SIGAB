class Product {
  int idProduct;
  String productName;
  String animalType;
  String productType;
  double price;
  bool state;

  Product({
    required this.idProduct,
    required this.productName,
    required this.animalType,
    required this.productType,
    required this.price,
    required this.state,
  });

  factory Product.fromJSON(Map<String, dynamic> json) {
    return Product(
      idProduct: json['idProduct'] ?? 0,
      productName: json['productName'],
      animalType: json['animalType'],
      productType: json['productType'],
      price: json['price'] ?? 0.0,
      state: json['state'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProduct': idProduct,
      'productName': productName,
      'animalType': animalType,
      'productType': productType,
      'price': price,
      'state': state,
    };
  }

  @override
  String toString() {
    return 'product{idProduct: $idProduct, productName: $productName, animalType: $animalType, productType: $productType, price: $price, state: $state}';
  }
}
