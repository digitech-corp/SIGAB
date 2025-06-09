abstract class PaymentInfo {
  Map<String, dynamic> toJson();
}

class ContadoPaymentInfo extends PaymentInfo {
  final double importe;
  final double saldo;

  ContadoPaymentInfo({required this.importe, required this.saldo});

  factory ContadoPaymentInfo.fromJson(Map<String, dynamic> json) {
    return ContadoPaymentInfo(
      importe: json['importe'] ?? 0.0,
      saldo: json['saldo'] ?? 0.0,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'tipo': 'Contado',
        'importe': importe,
        'saldo': saldo,
      };
}

class CreditoPaymentInfo extends PaymentInfo {
  final int numeroCuotas;
  final double monto;
  final DateTime fechaPago;

  CreditoPaymentInfo({
    required this.numeroCuotas,
    required this.monto,
    required this.fechaPago,
  });

  factory CreditoPaymentInfo.fromJson(Map<String, dynamic> json) {
    return CreditoPaymentInfo(
      numeroCuotas: json['numeroCuotas'] ?? 0,
      monto: json['monto'] ?? 0.0,
      fechaPago: DateTime.tryParse(json['fechaPago']) ?? DateTime.now(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'tipo': 'Crédito',
        'numeroCuotas': numeroCuotas,
        'monto': monto,
        'fechaPago': fechaPago.toIso8601String(),
      };
}