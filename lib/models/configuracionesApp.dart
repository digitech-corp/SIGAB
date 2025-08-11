import 'package:balanced_foods/models/opcionCatalogo.dart';
import 'package:balanced_foods/models/tienda.dart';

class ConfiguracionesApp {
  final List<OpcionCatalogo> tipoImpresion;
  final List<OpcionCatalogo> motivosTraslado;
  final List<OpcionCatalogo> tipoEgreso;
  final List<OpcionCatalogo> documentosVenta;
  final List<OpcionCatalogo> documentosVentaReducido;
  final List<OpcionCatalogo> tipoMoneda;
  final List<OpcionCatalogo> tipoPago;
  final List<OpcionCatalogo> tipoPagoReducido;
  final List<OpcionCatalogo> tipoCompra;
  final List<OpcionCatalogo> tipoVenta;
  final List<OpcionCatalogo> documentosCompra;
  final List<Tienda> tiendas;
  final List<Tienda> tiendasVenta;

  ConfiguracionesApp({
    required this.tipoImpresion,
    required this.motivosTraslado,
    required this.tipoEgreso,
    required this.documentosVenta,
    required this.documentosVentaReducido,
    required this.tipoMoneda,
    required this.tipoPago,
    required this.tipoPagoReducido,
    required this.tipoCompra,
    required this.tipoVenta,
    required this.documentosCompra,
    required this.tiendas,
    required this.tiendasVenta,
  });

  factory ConfiguracionesApp.fromJson(Map<String, dynamic> json) {
    List<OpcionCatalogo> parseOpciones(String key) =>
        (json[key] as List).map((item) => OpcionCatalogo.fromJSON(item)).toList();

    return ConfiguracionesApp(
      tipoImpresion: parseOpciones('tipo_impresion'),
      motivosTraslado: parseOpciones('motivos_traslado'),
      tipoEgreso: parseOpciones('tipo_egreso'),
      documentosVenta: parseOpciones('documentos_venta'),
      documentosVentaReducido: parseOpciones('documentos_venta_reducido'),
      tipoMoneda: parseOpciones('tipo_moneda'),
      tipoPago: parseOpciones('tipo_pago'),
      tipoPagoReducido: parseOpciones('tipo_pago_reducido'),
      tipoCompra: parseOpciones('tipo_compra'),
      tipoVenta: parseOpciones('tipo_venta'),
      documentosCompra: parseOpciones('documentos_compra'),
      tiendas: (json['tiendas'] as List).map((item) => Tienda.fromJson(item)).toList(),
      tiendasVenta: (json['tiendas_venta'] as List).map((item) => Tienda.fromJson(item)).toList(),
    );
  }
}
