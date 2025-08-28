class Product {
  int idProduct;
  String? dateCreated;
  String? numParte;
  String productName;
  String? descripcion;
  String? especificacionTecnica;
  int? idProductType;
  int? idAnimal;
  int? idFamily;
  int? idPresentacion;
  int? idUnidadMedida;
  int? moneda;
  int? igvType;
  double? priceCompra;
  double price;
  String? codSunat;
  int? stockMin;
  String? codBarras;
  int? anioGarantia;
  int? vecesVendido;
  String? colors;
  String? sizes;
  int? state;
  int? idCategoria;
  String? dataTable;
  int? stockActualEmpresa;
  String unidadMedida;
  String? imagen;
  String? nombreFormula;
  String? versionFormula;
  String animalType;
  String productType;

  Product({
    required this.idProduct,
    this.dateCreated,
    this.numParte,
    required this.productName,
    this.descripcion,
    this.especificacionTecnica,
    this.idProductType,
    this.idAnimal,
    this.idFamily,
    this.idPresentacion,
    this.idUnidadMedida,
    this.moneda,
    this.igvType,
    this.priceCompra,
    required this.price,
    this.codSunat,
    this.stockMin,
    this.codBarras,
    this.anioGarantia,
    this.vecesVendido,
    this.colors,
    this.sizes,
    this.state,
    this.idCategoria,
    this.dataTable,
    this.stockActualEmpresa,
    required this.unidadMedida,
    this.imagen,
    this.nombreFormula,
    this.versionFormula,
    required this.animalType,
    required this.productType,
  });

  factory Product.fromJSON(Map<String, dynamic> json) {
    String dataTablas = json['data_tablas'] ?? '';
    List<String> partes = dataTablas.split('__');

    String productType = partes.isNotEmpty ? partes.first : '';
    String animalType = partes.isNotEmpty ? partes.last : '';

    double _toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    int? _toInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    return Product(
      idProduct: json['id'] ?? 0,
      dateCreated: json['fecha_creado'] ?? '',
      numParte: json['num_parte'],
      productName: json['nombre'] ?? '',
      descripcion: json['descripcion'],
      especificacionTecnica: json['especificacion_tecnica'],
      idProductType: json['id_tipo_producto'] ?? 0,
      idAnimal: json['id_animal'] ?? 0,
      idFamily: json['id_familia'],
      idPresentacion: json['id_presentacion'] ?? 0,
      idUnidadMedida: json['id_unidad_medida'] ?? 0,
      moneda: json['moneda'] ?? 0,
      igvType: json['tipo_igv'] ?? 0,
      priceCompra: _toDouble(json['valor_compra_base']),
      price: _toDouble(json['valor_venta_base']),
      codSunat: json['cod_sunat'],
      stockMin: json['stock_min'],
      codBarras: json['cod_barras'],
      anioGarantia: json['anio_garantia'],
      vecesVendido: json['veces_vendido'],
      colors: json['colores'],
      sizes: json['tallas'],
      state: json['estado'] ?? 1,
      idCategoria: json['id_categoria'],
      dataTable: dataTablas,
      stockActualEmpresa: _toInt(json['stock_actual_empresa']),
      unidadMedida: json['unidad_medida'] ?? '',
      imagen: json['imagen'],
      nombreFormula: json['nombre_formula'] ?? '',
      versionFormula: json['version_formula'] ?? '',
      animalType: animalType,
      productType: productType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': idProduct,
      'fecha_creado': dateCreated,
      'num_parte': numParte,
      'nombre': productName,
      'descripcion': descripcion,
      'especificacion_tecnica': especificacionTecnica,
      'id_tipo_producto': idProductType,
      'id_animal': idAnimal,
      'id_familia': idFamily,
      'id_presentacion': idPresentacion,
      'id_unidad_medida': idUnidadMedida,
      'moneda': moneda,
      'tipo_igv': igvType,
      'valor_compra_base': priceCompra,
      'valor_venta_base': price,
      'cod_sunat': codSunat,
      'stock_min': stockMin,
      'cod_barras': codBarras,
      'anio_garantia': anioGarantia,
      'veces_vendido': vecesVendido,
      'colores': colors,
      'tallas': sizes,
      'estado': state,
      'id_categoria': idCategoria,
      'data_tablas': dataTable,
      'stock_actual_empresa': stockActualEmpresa,
      'unidad_medida': unidadMedida,
      'imagen': imagen,
      'nombre_formula': nombreFormula,
      'version_formula': versionFormula,
      'animalType': animalType,
      'productType': productType,
    };
  }

  @override
  String toString() {
    return 'Product(id: $idProduct, name: $productName, type: $productType, animal: $animalType, price: $price)';
  }

  Product copyWith({
    int? idProduct,
    String? dateCreated,
    String? numParte,
    String? productName,
    String? descripcion,
    String? especificacionTecnica,
    int? idProductType,
    int? idAnimal,
    int? idFamily,
    int? idPresentacion,
    int? idUnidadMedida,
    int? moneda,
    int? igvType,
    double? priceCompra,
    double? price,
    String? codSunat,
    int? stockMin,
    String? codBarras,
    int? anioGarantia,
    int? vecesVendido,
    String? colors,
    String? sizes,
    int? state,
    int? idCategoria,
    String? dataTable,
    int? stockActualEmpresa,
    String? unidadMedida,
    String? imagen,
    String? nombreFormula,
    String? versionFormula,
    String? animalType,
    String? productType,
  }) {
    return Product(
      idProduct: idProduct ?? this.idProduct,
      dateCreated: dateCreated ?? this.dateCreated,
      numParte: numParte ?? this.numParte,
      productName: productName ?? this.productName,
      descripcion: descripcion ?? this.descripcion,
      especificacionTecnica: especificacionTecnica ?? this.especificacionTecnica,
      idProductType: idProductType ?? this.idProductType,
      idAnimal: idAnimal ?? this.idAnimal,
      idFamily: idFamily ?? this.idFamily,
      idPresentacion: idPresentacion ?? this.idPresentacion,
      idUnidadMedida: idUnidadMedida ?? this.idUnidadMedida,
      moneda: moneda ?? this.moneda,
      igvType: igvType ?? this.igvType,
      priceCompra: priceCompra ?? this.priceCompra,
      price: price ?? this.price,
      codSunat: codSunat ?? this.codSunat,
      stockMin: stockMin ?? this.stockMin,
      codBarras: codBarras ?? this.codBarras,
      anioGarantia: anioGarantia ?? this.anioGarantia,
      vecesVendido: vecesVendido ?? this.vecesVendido,
      colors: colors ?? this.colors,
      sizes: sizes ?? this.sizes,
      state: state ?? this.state,
      idCategoria: idCategoria ?? this.idCategoria,
      dataTable: dataTable ?? this.dataTable,
      stockActualEmpresa: stockActualEmpresa ?? this.stockActualEmpresa,
      unidadMedida: unidadMedida ?? this.unidadMedida,
      imagen: imagen ?? this.imagen,
      nombreFormula: nombreFormula ?? this.nombreFormula,
      versionFormula: versionFormula ?? this.versionFormula,
      animalType: animalType ?? this.animalType,
      productType: productType ?? this.productType,
    );
  }
}
