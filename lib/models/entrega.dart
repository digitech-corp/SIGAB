import 'package:balanced_foods/models/EntregaDetail.dart';
import 'package:flutter/src/material/time.dart';

class Entrega{
  int? idEntrega;
  int idOrder;
  String incidencias;
  String firma;
  final List<EntregaDetail> images;
  TimeOfDay? entregaTime;
  DateTime? entregaDate;

  Entrega({
    this.idEntrega,
    required this.idOrder,
    required this.incidencias,
    required this.firma,
    required this.images,
    this.entregaTime,
    this.entregaDate,
  });

  factory Entrega.fromJSON(Map<String, dynamic> json){
    TimeOfDay? parseTime(String? time) {
      if (time == null) return null;
      final parts = time.split(':');
      return TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 0,
        minute: int.tryParse(parts[1]) ?? 0,
      );
    }
    return Entrega(
      idEntrega: json['idEntrega']?? 0,
      idOrder: json['idOrder']?? 0,
      incidencias: json['incidencias'],
      firma: json['firma'],
      images: (json['images'] as List<dynamic>)
          .map((d) => EntregaDetail.fromJSON(d))
          .toList(),
      entregaTime: parseTime(json['entregaTime']),
      entregaDate: json['entregaDate'] != null
          ? DateTime.tryParse(json['entregaDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idEntrega': idEntrega,
      'idOrder': idOrder,
      'incidencias': incidencias,
      'firma': firma,
      'images': images.map((d) => d.toJson()).toList(),
      'entregaTime': entregaTime != null
          ? '${entregaTime!.hour.toString().padLeft(2, '0')}:${entregaTime!.minute.toString().padLeft(2, '0')}:00'
          : null,
      'entregaDate': entregaDate?.toIso8601String().split('T').first,
    };
  }

  @override
  String toString() {
    return 'Entrega{idEntrega: $idEntrega, idOrder: $idOrder, incidencias: $incidencias, firma: $firma, images: $images, entregaTime: $entregaTime, entregaDate: $entregaDate}';
  }
}
