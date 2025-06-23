class Cuota {
  final double monto;
  final DateTime fecha;

  Cuota({required this.monto, required this.fecha});

  factory Cuota.fromJson(Map<String, dynamic> json) {
    return Cuota(
      monto: (json['monto'] ?? 0.0).toDouble(),
      fecha: DateTime.tryParse(json['fecha']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'monto': monto,
        'fecha': fecha.toIso8601String(),
      };
}