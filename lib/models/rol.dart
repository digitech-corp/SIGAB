class Rol{
  int? id;
  String nombre;
  DateTime? fechaRegistro;
  String? paginaInicial;
  int? tipoActividad;
  String? permisos;

  Rol({
    this.id,
    required this.nombre,
    this.fechaRegistro,
    this.paginaInicial,
    this.tipoActividad,
    this.permisos
  });

  factory Rol.fromJSON(Map<String, dynamic> json){
     return Rol(
      id: json['id'] ?? 0,
      nombre: json['nombre'],
      fechaRegistro: json['fecha_registro'],
      paginaInicial: json['pagina_inicial'],
      tipoActividad: json['tipo_actividad'] ?? 0,
      permisos: json['permisos']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'fecha_registro': fechaRegistro,
      'pagina_inicial': paginaInicial,
      'tipo_actividad': tipoActividad,
      'permisos': permisos
    };
  }

  @override
  String toString() {
    return 'Rol{id: $id, nombre: $nombre, fecha_registro: $fechaRegistro, pagina_inicial: $paginaInicial, tipo_actividad: $tipoActividad, permisos: $permisos}';
  }
}
