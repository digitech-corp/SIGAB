import 'package:flutter/material.dart';

class Order{
  int idOrder;
  String paymentMethod;
  double subtotal;
  double igv;
  double total;
  String? deliveryLocation;
  DateTime? deliveryDate;
  TimeOfDay? deliveryTime;
  String? additionalInformation;
  String? state;

  Order({
    required this.idOrder,
    required this.paymentMethod,
    required this.subtotal,
    required this.igv,
    required this.total,
    this.deliveryLocation,
    this.deliveryDate,
    this.deliveryTime,
    this.additionalInformation,
    this.state,
  });

  factory Order.fromJSON(Map<String, dynamic> json){
     return Order(
      idOrder: json['idOrder']?? 0,
      paymentMethod: json['paymentMethod'],
      subtotal: json['subtotal']?? 0,
      igv: json['igv']?? 0.0,
      total: json['total']?? 0.0,
      deliveryLocation: json['deliveryLocation'],
      deliveryDate: json['deliveryDate'],
      deliveryTime: json['deliveryTime'],
      additionalInformation: json['additionalInformation'],
      state: json['state']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idOrder': idOrder,
      'paymentMethod': paymentMethod,
      'subtotal': subtotal,
      'igv': igv,
      'total': total,
      'deliveryLocation': deliveryLocation,
      'deliveryDate': deliveryDate,
      'deliveryTime': deliveryTime,
      'additionalInformation': additionalInformation,
      'state': state,
    };
  }

  @override
  String toString() {
    return 'Order{idOrder: $idOrder, paymentMethod: $paymentMethod, subtotal: $subtotal, igv: $igv, total: $total, deliveryLocation: $deliveryLocation, deliveryDate: $deliveryDate, deliveryTime: $deliveryTime, additionalInformation: $additionalInformation, state: $state}';
  }
}
