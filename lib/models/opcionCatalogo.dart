class OpcionCatalogo {
  final int id;
  final String tabla;
  final int codigo;
  final String nombre;
  final String valorAdicionalOpcional;
  final String ingresadoPor;

  OpcionCatalogo({
    required this.id,
    required this.tabla,
    required this.codigo,
    required this.nombre,
    required this.valorAdicionalOpcional,
    required this.ingresadoPor,
  });

  factory OpcionCatalogo.fromJSON(Map<String, dynamic> json) {
    return OpcionCatalogo(
      id: json['id'],
      tabla: json['tabla'],
      codigo: json['codigo'],
      nombre: json['nombre'],
      valorAdicionalOpcional: json['valor_adicional_opcional'],
      ingresadoPor: json['ingresado_por'],
    );
  }
}
