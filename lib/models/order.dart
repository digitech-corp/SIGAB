import 'package:balanced_foods/models/orderDetail.dart';
import 'package:flutter/material.dart';

class Order{
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
  });

  factory Order.fromJSON(Map<String, dynamic> json){
     return Order(
      idOrder: json['idOrder'],
      idCustomer: json['idCustomer'] ?? 0, // Assuming idCustomer is required
      paymentMethod: json['paymentMethod'],
      receiptType: json['receiptType'],
      subtotal: json['subtotal']?? 0,
      igv: json['igv']?? 0.0,
      total: json['total']?? 0.0,
      deliveryLocation: json['deliveryLocation'],
      deliveryDate: json['deliveryDate'] != null
        ? DateTime.tryParse(json['deliveryDate'])
        : null,
      deliveryTime: json['deliveryTime'] != null
        ? Order._parseTimeOfDay(json['deliveryTime'])
        : null,
      additionalInformation: json['additionalInformation'],
      state: json['state'],
      paymentState: json['paymentState'],
      timeCreated: json['timeCreated'] != null
        ? Order._parseTimeOfDay(json['timeCreated'])
        : null,
      dateCreated: json['dateCreated'] != null
        ? DateTime.tryParse(json['dateCreated'])
        : null,
      details: (json['details'] as List<dynamic>)
          .map((d) => OrderDetail.fromJSON(d))
          .toList(),
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
      "details": details.map((d) => d.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Order{idOrder: $idOrder, idCustomer: $idCustomer, paymentMethod: $paymentMethod, receiptType: $receiptType, subtotal: $subtotal, igv: $igv, total: $total, deliveryLocation: $deliveryLocation, deliveryDate: $deliveryDate, deliveryTime: $deliveryTime, additionalInformation: $additionalInformation, state: $state, paymentState: $paymentState, timeCreated: $timeCreated, dateCreated: $dateCreated, details: $details}';
  }

  static TimeOfDay _parseTimeOfDay(String timeString) {
    final parts = timeString.split(":");
    if (parts.length >= 2) {
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      return TimeOfDay(hour: hour, minute: minute);
    }
    return const TimeOfDay(hour: 0, minute: 0);
  }
}
