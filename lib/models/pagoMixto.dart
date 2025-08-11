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
    return PagoMixto(
      id: json['id'],
      monto: (json['monto'] as num).toDouble(),
      numeroOperacion: json['numero_operacion'],
    );
  }
  
  @override
  String toString() => toJson().toString();
}
