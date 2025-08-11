class PedidoResumen {
  final int id;
  final String comprobante;
  final String fechaEmision;
  final double totalVenta;
  final int idMoneda;
  final String nombreTipoPago;
  final double totalPagado;

  PedidoResumen({
    required this.id,
    required this.comprobante,
    required this.fechaEmision,
    required this.totalVenta,
    required this.idMoneda,
    required this.nombreTipoPago,
    required this.totalPagado,
  });

  factory PedidoResumen.fromJson(Map<String, dynamic> json) => PedidoResumen(
    id: json['id'],
    comprobante: json['comprobante'] ?? '',
    fechaEmision: json['fecha_emision'] ?? '',
    totalVenta: double.tryParse(json['total_venta'].toString()) ?? 0.0,
    idMoneda: json['id_moneda'] ?? 0,
    nombreTipoPago: json['nombre_tipo_pago'] ?? '',
    totalPagado: double.tryParse(json['total_pagado'].toString()) ?? 0.0,
  );
}
