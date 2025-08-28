class PagoMixto {
  final int id;
  final double monto;
  final String numeroOperacion;

  PagoMixto({
    required this.id,
    required this.monto,
    required this.numeroOperacion,
  });

  // Para convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': 16,
      'monto': monto,
      'numero_operacion': numeroOperacion,
    };
  }

  // Para construir desde JSON (opcional)
  factory PagoMixto.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }
    return PagoMixto(
      id: json['id'],
      monto: _toDouble(json['monto']),
      numeroOperacion: json['numero_operacion'],
    );
  }
  
  @override
  String toString() => toJson().toString();
}
