class OrderDetail {
  int idProducto;
  int quantity;
  double unitPrice;
  double partialPrice;
  int idCustomer;

  OrderDetail ({
    required this.idProducto,
    required this.quantity,
    required this.unitPrice,
    required this.partialPrice,
    required this.idCustomer
  });

  factory OrderDetail.fromJSON(Map<String, dynamic> json){
     return OrderDetail (
      idProducto: json['idProducto'],
      quantity: json['quantity']?? 0,
      unitPrice: json['unitPrice']?? 0.0,
      partialPrice: json['partialPrice']?? 0.0,
      idCustomer: json['idCustomer']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProducto': idProducto,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'partialPrice': partialPrice,
      'idCustomer': idCustomer
    };
  }

  @override
  String toString() {
    return 'OrderDetail{idProducto: $idProducto, quantity: $quantity, unitPrice: $unitPrice, partialPrice: $partialPrice, idCustomer: $idCustomer}';
  }
}
