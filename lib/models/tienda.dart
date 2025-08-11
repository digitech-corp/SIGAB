class Tienda {
  final int id;
  final String nombre;
  final String direccion;
  final String ubigeo;
  final String correo;
  final String telefono;
  final String serieCotizacion;
  final String serieBoleta;
  final String serieFactura;
  final String serieRecibo;
  final String serieNcFactura;
  final String serieNcBoleta;
  final String serieNdFactura;
  final String serieNdBoleta;
  final String serieGuia;
  final String serieGuiaTransportista;
  final String serieOrdenCompra;
  final int redondeo;
  final int principal;
  final int capacidadM2;
  final int estado;
  final int mostrarWeb;

  Tienda({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.ubigeo,
    required this.correo,
    required this.telefono,
    required this.serieCotizacion,
    required this.serieBoleta,
    required this.serieFactura,
    required this.serieRecibo,
    required this.serieNcFactura,
    required this.serieNcBoleta,
    required this.serieNdFactura,
    required this.serieNdBoleta,
    required this.serieGuia,
    required this.serieGuiaTransportista,
    required this.serieOrdenCompra,
    required this.redondeo,
    required this.principal,
    required this.capacidadM2,
    required this.estado,
    required this.mostrarWeb,
  });

  factory Tienda.fromJson(Map<String, dynamic> json) {
    return Tienda(
      id: json['id'],
      nombre: json['nombre'],
      direccion: json['direccion'],
      ubigeo: json['ubigeo'],
      correo: json['correo'],
      telefono: json['telefono'],
      serieCotizacion: json['serie_cotizacion'],
      serieBoleta: json['serie_boleta'],
      serieFactura: json['serie_factura'],
      serieRecibo: json['serie_recibo'],
      serieNcFactura: json['serie_nc_factura'],
      serieNcBoleta: json['serie_nc_boleta'],
      serieNdFactura: json['serie_nd_factura'],
      serieNdBoleta: json['serie_nd_boleta'],
      serieGuia: json['serie_guia'],
      serieGuiaTransportista: json['serie_guia_transportista'],
      serieOrdenCompra: json['serie_orden_compra'],
      redondeo: json['redondeo'],
      principal: json['principal'],
      capacidadM2: json['capacidad_m2'],
      estado: json['estado'],
      mostrarWeb: json['mostrar_web'],
    );
  }
}
