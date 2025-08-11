import 'package:balanced_foods/models/pedidoResumen.dart';

class ClienteRespuestaAPI {
  final int idListaPrecio;
  final String nroDocumento;
  final String nombres;
  final int idCliente;
  final String fotoPerfil;
  final String ruc;
  final String razonSocial;
  final String direccionAfiliada;
  final int idDatos;
  final String nombrePlan;
  final List<PedidoResumen> pedidos;

  ClienteRespuestaAPI({
    required this.idListaPrecio,
    required this.nroDocumento,
    required this.nombres,
    required this.idCliente,
    required this.fotoPerfil,
    required this.ruc,
    required this.razonSocial,
    required this.direccionAfiliada,
    required this.idDatos,
    required this.nombrePlan,
    required this.pedidos,
  });

  factory ClienteRespuestaAPI.fromJson(Map<String, dynamic> json) =>
    ClienteRespuestaAPI(
      idListaPrecio: json['id_lista_precio'],
      nroDocumento: json['nro_documento'] ?? '',
      nombres: json['nombres'] ?? '',
      idCliente: json['id_cliente'] ?? 0,
      fotoPerfil: json['foto_perfil'] ?? '',
      ruc: json['ruc'] ?? '',
      razonSocial: json['razon_social'] ?? '',
      direccionAfiliada: json['direccion_afiliada'] ?? '',
      idDatos: json['id_datos'],
      nombrePlan: json['nombre_plan'] ?? '',
      pedidos: (json['pedidos'] as List?)
        ?.map((x) => PedidoResumen.fromJson(x))
        .toList() ?? [],
    );
}
