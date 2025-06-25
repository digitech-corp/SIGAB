import 'package:balanced_foods/models/orderDetail.dart';
import 'package:balanced_foods/models/paymentInfo.dart';
import 'package:flutter/material.dart';

class Order {
  int? idOrder;
  int idCustomer;
  String paymentMethod;
  String receiptType;
  double subtotal;
  double igv;
  double total;
  String? deliveryLocation;
  DateTime? deliveryDate;
  TimeOfDay? deliveryTime;
  String? additionalInformation;
  String? state;
  String? paymentState;
  TimeOfDay? timeCreated;
  DateTime? dateCreated;
  final List<OrderDetail> details;
  PaymentInfo? paymentInfo;

  Order({
    this.idOrder,
    required this.idCustomer,
    required this.paymentMethod,
    required this.receiptType,
    required this.subtotal,
    required this.igv,
    required this.total,
    this.deliveryLocation,
    this.deliveryDate,
    this.deliveryTime,
    this.additionalInformation,
    this.state,
    this.paymentState,
    this.timeCreated,
    this.dateCreated,
    required this.details,
    this.paymentInfo,
  });

  factory Order.fromJSON(Map<String, dynamic> json) {
    TimeOfDay? parseTime(String? time) {
      if (time == null) return null;
      final parts = time.split(':');
      return TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 0,
        minute: int.tryParse(parts[1]) ?? 0,
      );
    }

    // Deserialización de paymentInfo (espera una lista con un solo objeto)
    PaymentInfo? paymentInfo;
    if (json['paymentInfo'] != null && (json['paymentInfo'] as List).isNotEmpty) {
      final info = (json['paymentInfo'] as List).first;
      if (info['tipo'] == 'Crédito') {
        paymentInfo = CreditoPaymentInfo.fromJson(info);
      } else if (info['tipo'] == 'Contado') {
        paymentInfo = ContadoPaymentInfo.fromJson(info);
      }
    }

    return Order(
      idOrder: json['idOrder'],
      idCustomer: json['idCustomer'] ?? 0,
      paymentMethod: json['paymentMethod'],
      receiptType: json['receiptType'],
      subtotal: (json['subtotal'] as num).toDouble(),
      igv: (json['igv'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      deliveryLocation: json['deliveryLocation'],
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.tryParse(json['deliveryDate'])
          : null,
      deliveryTime: parseTime(json['deliveryTime']),
      additionalInformation: json['additionalInformation'],
      state: json['state'],
      paymentState: json['paymentState'],
      timeCreated: parseTime(json['timeCreated']),
      dateCreated: json['dateCreated'] != null
          ? DateTime.tryParse(json['dateCreated'])
          : null,
      details: (json['details'] as List<dynamic>)
          .map((d) => OrderDetail.fromJSON(d))
          .toList(),
      paymentInfo: paymentInfo,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idOrder': idOrder,
      'idCustomer': idCustomer,
      'paymentMethod': paymentMethod,
      'receiptType': receiptType,
      'subtotal': subtotal,
      'igv': igv,
      'total': total,
      'deliveryLocation': deliveryLocation,
      'deliveryDate': deliveryDate?.toIso8601String().split('T').first,
      'deliveryTime': deliveryTime != null
          ? '${deliveryTime!.hour.toString().padLeft(2, '0')}:${deliveryTime!.minute.toString().padLeft(2, '0')}:00'
          : null,
      'additionalInformation': additionalInformation,
      'state': state,
      'paymentState': paymentState,
      'timeCreated': timeCreated != null
          ? '${timeCreated!.hour.toString().padLeft(2, '0')}:${timeCreated!.minute.toString().padLeft(2, '0')}:00'
          : null,
      'dateCreated': dateCreated?.toIso8601String().split('T').first,
      'details': details.map((d) => d.toJson()).toList(),
      'paymentInfo': paymentInfo != null ? [paymentInfo!.toJson()] : [],
    };
  }

  @override
  String toString() {
    return 'Order{idOrder: $idOrder, idCustomer: $idCustomer, paymentMethod: $paymentMethod, receiptType: $receiptType, subtotal: $subtotal, igv: $igv, total: $total, deliveryLocation: $deliveryLocation, deliveryDate: $deliveryDate, deliveryTime: $deliveryTime, additionalInformation: $additionalInformation, state: $state, paymentState: $paymentState, timeCreated: $timeCreated, dateCreated: $dateCreated, details: $details, paymentInfo: $paymentInfo}';
  }
}