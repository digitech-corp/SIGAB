import 'package:balanced_foods/models/cuota.dart';

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
  final List<Cuota> cuotas;

  CreditoPaymentInfo({required this.cuotas});

  factory CreditoPaymentInfo.fromJson(Map<String, dynamic> json) {
    return CreditoPaymentInfo(
      cuotas: (json['cuotas'] as List<dynamic>)
          .map((e) => Cuota.fromJson(e))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'tipo': 'Crédito',
        'cuotas': cuotas.map((c) => c.toJson()).toList(),
      };
}