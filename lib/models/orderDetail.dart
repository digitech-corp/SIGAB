class OrderDetail {
  int idProducto;
  int quantity;
  double unitPrice;
  double partialPrice;

  OrderDetail ({
    required this.idProducto,
    required this.quantity,
    required this.unitPrice,
    required this.partialPrice
  });

  factory OrderDetail.fromJSON(Map<String, dynamic> json){
     return OrderDetail (
      idProducto: json['idProducto'],
      quantity: json['quantity']?? 0,
      unitPrice: json['unitPrice']?? 0.0,
      partialPrice: json['partialPrice']?? 0.0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProducto': idProducto,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'partialPrice': partialPrice
    };
  }

  @override
  String toString() {
    return 'OrderDetail{idProducto: $idProducto, quantity: $quantity, unitPrice: $unitPrice, partialPrice: $partialPrice}';
  }
}
