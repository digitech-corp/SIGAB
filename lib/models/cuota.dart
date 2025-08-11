class Cuota {
  int? id;
  int? idVenta;
  double? monto;
  DateTime? fecha;

  Cuota({
    this.id,
    this.idVenta,
    this.monto,
    this.fecha,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_venta': idVenta,
      'monto_cuota': monto,
      'fecha_vencimiento': fecha!.toIso8601String().split('T')[0],
    };
  }

  factory Cuota.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }
    return Cuota(
      id: json['id'],
      idVenta: json['id_venta'],
      monto: _toDouble(json['monto_cuota']),
      fecha: (json['fecha_vencimiento'] is String)
          ? DateTime.tryParse(json['fecha_vencimiento'])
          : null,
    );
  }
  
  @override
  String toString() => toJson().toString();
}
