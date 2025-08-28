import 'package:balanced_foods/models/EntregaDetail.dart';
import 'package:flutter/src/material/time.dart';
class Entrega{
  int? id;
  int? idOrder;
  int? idCustomer;
  int? idEstado;
  int? idEstadoAnterior;
  int? idEstadoNuevo;
  int? idRuta;
  int? idPersonal;
  int? idVehiculo;
  int? idTransportista;
  DateTime? fechaProgramacion;
  TimeOfDay? horaProgramacion;
  String? prioridad;
  String? incidencias;
  String? archivoEvidencia;
  String? serie;
  int? numero;
  String? fechaEmision;
  String? direccionEntrega;
  String? productos;
  String? transportista;
  double? peso;
  String? nombres;
  String? nroDocumento;
  String? nombreRuta;
  String? estado;
  String? nombrePersonal;

  String? firma;
  // final List<EntregaDetail>? images;

  Entrega({
    this.id,
    this.idOrder,
    this.idCustomer,
    this.idEstado,
    this.idEstadoAnterior,
    this.idEstadoNuevo,
    this.idRuta,
    this.idPersonal,
    this.idVehiculo,
    this.idTransportista,
    this.fechaProgramacion,
    this.horaProgramacion,
    this.prioridad,
    this.incidencias,
    this.archivoEvidencia,
    this.serie,
    this.numero,
    this.fechaEmision,
    this.direccionEntrega,
    this.productos,
    this.transportista,
    this.peso,
    this.nombres,
    this.nroDocumento,
    this.nombreRuta,
    this.estado,
    this.nombrePersonal,

    this.firma,
    // this.images,
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
      id: json['id'],
      idOrder: json['id_venta'],
      idCustomer: json['id_cliente'],
      idEstado: json['id_estado'],
      idRuta: json['id_ruta'],
      idPersonal: json['id_personal'],
      idVehiculo: json['id_vehiculo'],
      idTransportista: json['id_transportista'],
      fechaProgramacion: DateTime.tryParse(json['fecha'] ?? ''),
      horaProgramacion: parseTime(json['hora']),
      prioridad: json['prioridad'],
      incidencias: json['comentarios'],
      archivoEvidencia: json['archivo_evidencia'],
      serie: json['serie'],
      numero: json['numero'],
      fechaEmision: json['fecha_emision'],
      direccionEntrega: json['direccion_entrega'],
      productos: json['productos'],
      transportista: json['transportista'],
      peso: (json['peso'] as num?)?.toDouble(),
      nombres: json['nombres'],
      nroDocumento: json['nro_documento'],
      nombreRuta: json['nombre_ruta'],
      estado: json['estado'] ?? json['nombre_estado'],
      nombrePersonal: json['nombre_personal'],

      // firma: json['firma'],
      // images: (json['images'] as List<dynamic>?)
      //     ?.map((item) => EntregaDetail.fromJSON(item))
      //     .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_estado_venta_anterior': idEstadoAnterior,
      'nuevo_estado': idEstadoNuevo,
      'comentarios': incidencias,
      'archivo_evidencia': archivoEvidencia,
      'firma': firma,
    };
  }

  @override
  String toString() {
    return 'Entrega{id: $id, idOrder: $idOrder, id_cliente: $idCustomer, idEstado: $idEstado, id_estado_venta_anterior: $idEstadoAnterior, nuevo_estado: $idEstadoNuevo, idRuta: $idRuta, idPersonal: $idPersonal, idVehiculo: $idVehiculo, idTransportista: $idTransportista, fechaProgramacion: $fechaProgramacion, horaProgramacion: $horaProgramacion, prioridad: $prioridad, incidencias: $incidencias, archivoEvidencia: $archivoEvidencia, serie: $serie, numero: $numero, fechaEmision: $fechaEmision, direccionEntrega: $direccionEntrega, productos: $productos, peso: $peso, nombres: $nombres, nroDocumento: $nroDocumento, nombreRuta: $nombreRuta, estado: $estado, nombre_personal: $nombrePersonal}';
  }
}
