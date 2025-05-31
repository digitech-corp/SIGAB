class PriceDetail {
  int idProducto;
  double unitPrice;

  PriceDetail ({
    required this.idProducto,
    required this.unitPrice
  });

  factory PriceDetail.fromJSON(Map<String, dynamic> json){
     return PriceDetail (
      idProducto: json['idProducto'],
      unitPrice: json['unitPrice']?? 0.0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProducto': idProducto,
      'unitPrice': unitPrice
    };
  }

  @override
  String toString() {
    return 'PriceDetail{idProducto: $idProducto, unitPrice: $unitPrice}';
  }
}
