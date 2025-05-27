class OrderDetail {
  int idProducto;
  int cantidad;
  double precioUnitario;
  double precioParcial;
  int idCustomer;

  OrderDetail ({
    required this.idProducto,
    required this.cantidad,
    required this.precioUnitario,
    required this.precioParcial,
    required this.idCustomer
  });

  factory OrderDetail.fromJSON(Map<String, dynamic> json){
     return OrderDetail (
      idProducto: json['idProducto'],
      cantidad: json['cantidad']?? 0,
      precioUnitario: json['precioUnitario']?? 0.0,
      precioParcial: json['precioParcial']?? 0.0,
      idCustomer: json['idCustomer']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'idOrder': idOrder,
      'idProducto': idProducto,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      'precioParcial': precioParcial,
      'idCustomer': idCustomer
    };
  }

  @override
  String toString() {
    return 'OrderDetail{idProducto: $idProducto, cantidad: $cantidad, precioUnitario: $precioUnitario, precioParcial: $precioParcial, idCustomer: $idCustomer}';
  }
}
