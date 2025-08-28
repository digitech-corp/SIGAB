import 'package:balanced_foods/models/cuota.dart';
import 'package:balanced_foods/models/orderDetail.dart';
import 'package:balanced_foods/models/pagoMixto.dart';
import 'package:flutter/material.dart';

class Order {
  int? idOrder;
  int? idTipoDocumento;
  int? idCustomer;
  int? idSucursal;
  String? numComprobante;
  TimeOfDay? horaRegistro;
  DateTime? fechaEmision;
  DateTime? fechaRegistro;
  double? total;
  int? idPersonal;
  int? idMoneda;
  String? vendedor;
  int? state;
  String? razonSocial;
  String? deliveryLocation;
  DateTime? deliveryDate;
  TimeOfDay? deliveryTime;
  String? additionalInformation;
  DateTime? fechaVencimiento;
  int? idPaymentMethod;
  int? idTipoVenta;
  String? paymentMethod;

  String? serie;
  int? numero;
  double? totalPagado;
  String? nroDocumento;
  String? nombreTipoDocumento;
  int? codigoTipoPago;
  String? nombreSucursal;
  String? nombreCliente;

  List<OrderDetail>? details;
  String? cliente;
  List<Cuota>? cuotas;
  List<PagoMixto>? pagosMixtos;

  int? idMotivoNota;
  int? idMotivoNotaDebito;
  String? nroOperacion;
  String? serieModifica;
  String? nroModifica;
  DateTime? dateModifica;
  double? baseImponible;
  double? totalExonerado;
  double? totalIgv;
  String? detraccion;
  int? idTipoDetraccion;
  double? porcentajeDetraccion;
  double? totalDetraccion;
  int? idTipoRetencion;
  double? totalRetencion;
  String? direccionClienteVenta;
  int? tipoCambio;
  String? observaciones;
  int? idTipoImpresion;
  int? creditoDias;

  int? estadoFacturacion;

  Order({
    this.idOrder,
    this.idTipoDocumento,
    this.idCustomer,
    this.idSucursal,
    this.numComprobante,
    this.horaRegistro,
    this.fechaEmision,
    this.fechaRegistro,
    this.total,
    this.idPersonal,
    this.idMoneda,
    this.cliente,
    this.vendedor,
    this.state,
    this.razonSocial,
    this.deliveryLocation,
    this.deliveryDate,
    this.deliveryTime,
    this.fechaVencimiento,
    this.additionalInformation,
    this.idTipoVenta,
    this.idPaymentMethod,
    this.paymentMethod,

    this.serie,
    this.numero,
    this.totalPagado,
    this.nroDocumento,
    this.nombreTipoDocumento,
    this.codigoTipoPago,
    this.nombreSucursal,
    this.nombreCliente,

    this.idMotivoNota,
    this.idMotivoNotaDebito,
    this.nroOperacion,
    this.serieModifica,
    this.nroModifica,
    this.dateModifica,
    this.baseImponible,
    this.totalExonerado,
    this.totalIgv,
    this.detraccion,
    this.idTipoDetraccion,
    this.porcentajeDetraccion,
    this.totalDetraccion,
    this.idTipoRetencion,
    this.totalRetencion,
    this.direccionClienteVenta,
    this.tipoCambio,
    this.observaciones,
    this.idTipoImpresion,
    this.creditoDias,

    this.details,
    this.cuotas,
    this.pagosMixtos,

    this.estadoFacturacion,
  });

  factory Order.fromJSON(Map<String, dynamic> json) {
    double _toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    TimeOfDay? parseTime(String? time) {
      if (time == null || time.isEmpty) return null;
      final parts = time.split(':');
      return TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 0,
        minute: int.tryParse(parts[1]) ?? 0,
      );
    }

    return Order(
      idOrder: json['id'],
      idTipoDocumento: json['id_tipo_documento'],
      idCustomer: json['id_cliente'],
      idSucursal: json['id_sucursal'],
      numComprobante: json['comprobante'] ?? json['numero_comprobante'],
      horaRegistro: parseTime(json['hora_registro']) ?? TimeOfDay(hour: 0, minute: 0),
      fechaEmision: (json['fecha_emision'] is String)
        ? DateTime.tryParse(json['fecha_emision'])
        : null,
      fechaRegistro: (json['fecha_registro'] is String)
        ? DateTime.tryParse(json['fecha_registro'])
        : null,
      total: _toDouble(json['total_venta']),
      idPersonal: json['id_personal'],
      idMoneda: json['id_moneda'],
      cliente: json['cliente'] ?? json['nombre_cliente'],
      vendedor: json['vendedor'],
      state: json['estado_registro'],
      razonSocial: json['razon_social'],
      deliveryLocation: json['direccion_entrega'],
      deliveryDate: (json['fecha_entrega'] is String)
          ? DateTime.tryParse(json['fecha_entrega'])
          : null,
      fechaVencimiento: (json['fecha_vencimiento'] is String)
          ? DateTime.tryParse(json['fecha_vencimiento'])
          : null,
      deliveryTime: parseTime(json['hora_entrega']),
      additionalInformation: json['referencia_entrega'],
      idPaymentMethod: json['id_tipo_pago'],
      paymentMethod: json['nombre_tipo_pago'],
      idTipoVenta: json['id_tipo_venta'],

      serie: json['serie'],
      numero: json['numero'],
      totalPagado: _toDouble(json['total_pagado']),
      nroDocumento: json['nro_documento'],
      nombreTipoDocumento: json['nombre_tipo_documento'],
      codigoTipoPago: json['codigo_tipo_pago'],
      nombreSucursal: json['nombre_sucursal'],
      nombreCliente: json['nombre_cliente'],

      idMotivoNota: json['id_motivo_nota'],
      idMotivoNotaDebito: json['id_motivo_nota_debito'],
      nroOperacion: json['nro_operacion'],
      serieModifica: json['serie_modifica'],
      nroModifica: json['numero_modifica'],
      dateModifica: (json['fecha_modifica'] is String)
          ? DateTime.tryParse(json['fecha_modifica'])
          : null,
      baseImponible: _toDouble(json['base_imponible']),
      totalExonerado: _toDouble(json['total_exonerado']),
      totalIgv: _toDouble(json['total_igv']),
      detraccion: json['tiene_detraccion'],
      idTipoDetraccion: json['id_tipo_detraccion'],
      porcentajeDetraccion: _toDouble(json['porcentaje_detraccion']),
      totalDetraccion: _toDouble(json['total_detraccion']),
      idTipoRetencion: json['id_tipo_retencion'],
      totalRetencion: _toDouble(json['total_retencion']),
      direccionClienteVenta: json['direccion_cliente_venta'],
      tipoCambio: json['tipo_cambio'],
      observaciones: json['observaciones'],
      idTipoImpresion: json['id_tipo_impresion'],
      creditoDias: json['credito_dias'],

      details: ((json['detalles'] as List<dynamic>?) ??
          (json['productos'] as List<dynamic>?) ??
          [])
        .map((d) => OrderDetail.fromJSON(d))
        .toList(),
      cuotas: ((json['cuotas'] as List<dynamic>?) ?? [])
        .map((d) => Cuota.fromJson(d))
        .toList(),
      pagosMixtos: ((json['tipo_pago'] as List<dynamic>?) ?? [])
        .map((d) => PagoMixto.fromJson(d))
        .toList(),
      estadoFacturacion: json['estado_facturacion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cabeza': {
        'id': idOrder,
        'id_tipo_documento': idTipoDocumento,
        'id_moneda': idMoneda,
        'id_tipo_pago': idPaymentMethod,
        'id_tipo_venta': idTipoVenta,
        'fecha_registro': fechaRegistro?.toIso8601String().split('T').first,
        'fecha_emision': fechaEmision?.toIso8601String().split('T').first,
        'id_cliente': idCustomer,
        'id_sucursal': idSucursal,
        'id_motivo_nota': idMotivoNota,
        'id_motivo_nota_debito': idMotivoNotaDebito,
        'nro_operacion': nroOperacion,
        'serie_modifica': serieModifica,
        'numero_modifica': nroModifica,
        'fecha_modifica': dateModifica?.toIso8601String().split('T').first,
        'base_imponible': baseImponible,
        'total_exonerado': totalExonerado,
        'total_igv': totalIgv,
        'total_venta': total,
        'tiene_detraccion': detraccion,
        'id_tipo_detraccion': idTipoDetraccion,
        'porcentaje_detraccion': porcentajeDetraccion,
        'total_detraccion': totalDetraccion,
        'id_tipo_retencion': idTipoRetencion,
        'total_retencion': totalRetencion,
        'estado_registro': state,
        'direccion_cliente_venta': direccionClienteVenta,
        'tipo_cambio': tipoCambio,
        'observaciones': observaciones,
        'direccion_entrega': deliveryLocation,
        'fecha_entrega': deliveryDate?.toIso8601String().split('T').first,
        'hora_entrega': deliveryTime != null
            ? '${deliveryTime!.hour.toString().padLeft(2, '0')}:${deliveryTime!.minute.toString().padLeft(2, '0')}'
            : null,
        'referencia_entrega': additionalInformation,
      },
      'detalles': details!.map((d) => d.toJson()).toList(),
      'cliente': {
        "id": null,
        "documento": "",
        "nombres": cliente ?? "",
        "direccion": "",
        "ruc_afiliada": "",
        "razon_social_afiliada": razonSocial ?? "",
        "direccion_afiliada": ""
      },
      'cuotas': cuotas?.map((c) => c.toJson()).toList() ,
      'pagosMixtos': pagosMixtos?.map((p) => p.toJson()).toList(),
    };
  }

  @override
  String toString() {
  final formattedDeliveryDate = deliveryDate;
  final formattedDeliveryTime = deliveryTime;

  return 'Order{'
    'id: $idOrder, '
    'id_tipo_documento: $idTipoDocumento, '
    'id_cliente: $idCustomer, '
    'id_sucursal: $idSucursal, '
    'numero_comprobante: $numComprobante, '
    'hora_registro: $horaRegistro, '
    'fecha_emision: $fechaEmision, '
    'fecha_registro: $fechaRegistro, '
    'total_venta: $total, '
    'id_personal: $idPersonal, '
    'id_moneda: $idMoneda, '
    'cliente: $cliente, '
    'vendedor: $vendedor, '
    'estado_registro: $state, '
    'razon_social: $razonSocial, '
    'direccion_entrega: $deliveryLocation, '
    'fecha_entrega: $formattedDeliveryDate, '
    'hora_entrega: $formattedDeliveryTime, '
    'referencia_entrega: $additionalInformation, '
    'id_tipo_pago: $idPaymentMethod, '
    'nombre_tipo_pago: $paymentMethod, '
    'id_tipo_venta: $idTipoVenta, '
    'productos: $details, '
    'cuotas: $cuotas, '
    'pagosMixtos: $pagosMixtos'
    'serie: $serie, '
    'numero: $numero, '
    'total_pagado: $totalPagado, '
    'nro_documento: $nroDocumento, '
    'nombre_tipo_documento: $nombreTipoDocumento, '
    'codigo_tipo_pago: $codigoTipoPago, '
    'nombre_sucursal: $nombreSucursal, '
    'nombre_cliente: $nombreCliente, '
    'id_motivo_nota: $idMotivoNota, '
    'id_motivo_nota_debito: $idMotivoNotaDebito, '
    'nro_operacion: $nroOperacion, '
    'serie_modifica: $serieModifica, '
    'numero_modifica: $nroModifica, '
    'fecha_modifica: $dateModifica, '
    'base_imponible: $baseImponible, '
    'total_exonerado: $totalExonerado, '
    'total_igv: $totalIgv, '
    'tiene_detraccion: $detraccion, '
    'id_tipo_detraccion: $idTipoDetraccion, '
    'porcentaje_detraccion: $porcentajeDetraccion, '
    'total_detraccion: $totalDetraccion, '
    'id_tipo_retencion: $idTipoRetencion, '
    'total_retencion: $totalRetencion, '
    'direccion_cliente_venta: $direccionClienteVenta, '
    'tipo_cambio: $tipoCambio, '
    'observaciones: $observaciones, '
    'estado_facturacion: $estadoFacturacion'
  '}';
  }
}
