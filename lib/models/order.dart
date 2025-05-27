import 'package:balanced_foods/models/orderDetail.dart';
import 'package:flutter/material.dart';

class Order{
  String paymentMethod;
  String receiptType;
  double subtotal;
  double igv;
  double total;
  String? deliveryLocation;
  DateTime? deliveryDate;
  TimeOfDay? deliveryTime;
  String? additionalInformation;
  final List<OrderDetail> details;

  Order({
    required this.paymentMethod,
    required this.receiptType,
    required this.subtotal,
    required this.igv,
    required this.total,
    this.deliveryLocation,
    this.deliveryDate,
    this.deliveryTime,
    this.additionalInformation,
    required this.details,
  });

  factory Order.fromJSON(Map<String, dynamic> json){
     return Order(
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
      details: json['details']
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      "details": details.map((d) => d.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Order{paymentMethod: $paymentMethod, receiptType: $receiptType, subtotal: $subtotal, igv: $igv, total: $total, deliveryLocation: $deliveryLocation, deliveryDate: $deliveryDate, deliveryTime: $deliveryTime, additionalInformation: $additionalInformation, details: $details}';
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
