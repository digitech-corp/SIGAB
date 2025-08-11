class OrderDetail {
  int? idProduct;
  double quantity;
  double unitPrice;
  double? importeNeto;
  String? descripcionItem;
  String? nombreAnimal;
  String? nombrePresentacion;
  String? nombreUm;
  int? cantidadUm;
  int? tipoIgv;
  String? detalleItem;
  int? idUnidadMedida;

  int? id;
  int? idVenta;
  int? numeroItem;
  String? detalle;
  double? descuento;
  String? serieAnticipo;
  int? numeroAnticipo;
  double? utilidad;

  OrderDetail ({
    this.idProduct,
    required this.quantity,
    required this.unitPrice,
    required this.importeNeto,
    required this.descripcionItem,
    this.nombreAnimal,
    this.nombrePresentacion,
    this.nombreUm,
    this.cantidadUm,
    this.tipoIgv,
    this.detalleItem,
    this.idUnidadMedida,
    this.id,
    this.idVenta,
    this.numeroItem,
    this.detalle,
    this.descuento,
    this.serieAnticipo,
    this.numeroAnticipo,
    this.utilidad,
  });

  factory OrderDetail.fromJSON(Map<String, dynamic> json){
    double _toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }
    
    return OrderDetail (
      idProduct: json['id_articulo']?? 0,
      quantity: _toDouble(json['cantidad']),
      unitPrice: _toDouble(json['precio_unitario']),
      importeNeto: _toDouble(json['importe_neto']),
      descripcionItem: json['descripcion_item'] ?? '',
      nombreAnimal: json['nombre_animal'] ?? '',
      nombrePresentacion: json['nombre_presentacion'] ?? '',
      nombreUm: json['nombre_um'] ?? json['nombre_unidad_medida'] ?? '',
      cantidadUm: json['cantidad_um'] ?? 0,
      tipoIgv: json['tipo_igv'],
      detalleItem: json['detalle_item'],
      idUnidadMedida: json['id_unidad_medida'],

      id: json['id'],
      idVenta: json['id_venta'],
      numeroItem: json['numero_item'],
      detalle: json['detalle'],
      descuento: _toDouble(json['descuento']),
      serieAnticipo: json['serie_anticipo'],
      numeroAnticipo: json['numero_anticipo'],
      utilidad: _toDouble(json['utilidad']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_articulo': idProduct,
      'cantidad': quantity,
      'precio_unitario': unitPrice,
      'importe_neto': importeNeto,
      'descripcion_item': descripcionItem,
      'nombre_animal': nombreAnimal,
      'nombre_presentacion': nombrePresentacion,
      'nombre_um': nombreUm,
      'cantidad_um': cantidadUm,
      'tipo_igv': tipoIgv,
      'detalle_item': detalleItem,
      'id_unidad_medida': idUnidadMedida,

      'id': id,
      'id_venta': idVenta,
      'numero_item': numeroItem,
      'detalle': detalle,
      'descuento': descuento,
      'serie_anticipo': serieAnticipo,
      'numero_anticipo': numeroAnticipo,
      'utilidad': utilidad,
    };
  }

  @override
  String toString() {
  return 'OrderDetail{'
    'id_articulo: $idProduct, '
    'cantidad: $quantity, '
    'precio_unitario: $unitPrice, '
    'importe_neto: $importeNeto, '
    'descripcion_item: $descripcionItem, '
    'nombre_animal: $nombreAnimal, '
    'nombre_presentacion: $nombrePresentacion, '
    'nombre_um: $nombreUm, '
    'cantidad_um: $cantidadUm, '
    'tipo_igv: $tipoIgv, '
    'detalle_item: $detalleItem, '
    'id_unidad_medida: $idUnidadMedida'
  '}';
  }
}
