class TipoCliente{
  int? id;
  String? tabla;
  int? codigo;
  String nombre;
  int? valorAdicionalOpcional;

  TipoCliente({
    this.id,
    this.tabla,
    this.codigo,
    required this.nombre,
    this.valorAdicionalOpcional
  });

  factory TipoCliente.fromJSON(Map<String, dynamic> json){
    int? _toInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }
     return TipoCliente(
      id: json['id'] ?? 0,
      tabla: json['tabla'],
      codigo: json['codigo'],
      nombre: json['nombre'],
      valorAdicionalOpcional: _toInt(json['valor_adicional_opcional']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tabla': tabla,
      'codigo': codigo,
      'nombre': nombre,
      'valor_adicional_opcional': valorAdicionalOpcional
    };
  }

  @override
  String toString() {
    return 'TipoCliente{id: $id, tabla: $tabla, codigo: $codigo, nombre: $nombre, valor_adicional_opcional: $valorAdicionalOpcional}';
  }
}
