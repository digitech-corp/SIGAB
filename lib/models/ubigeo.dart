class Ubigeo{
  int id;
  String ubiDepartamento;
  String ubiProvincia;
  String ubiDistrito;

  Ubigeo({
    required this.id,
    required this.ubiDepartamento,
    required this.ubiProvincia,
    required this.ubiDistrito
  });

  factory Ubigeo.fromJSON(Map<String, dynamic> json){
     return Ubigeo(
      id: json['id'] ?? 0,
      ubiDepartamento: json['ubi_departamento'] ?? '',
      ubiProvincia: json['ubi_provincia'] ?? '',
      ubiDistrito: json['ubi_distrito'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ubi_departamento': ubiDepartamento,
      'ubi_provincia': ubiProvincia,
      'ubi_distrito': ubiDistrito
    };
  }

  @override
  String toString() {
    return 'Ubigeo{id: $id, ubiDepartamento: $ubiDepartamento, ubiProvincia: $ubiProvincia, ubiDistrito: $ubiDistrito}';
  }
}
