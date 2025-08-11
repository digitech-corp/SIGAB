class Company{
  int? id;
  String razonSocial;
  String ruc;
  String direccion;
  String? companyWeb;

  Company({
    this.id,
    required this.razonSocial,
    required this.ruc,
    required this.direccion,
    this.companyWeb
  });

  factory Company.fromJSON(Map<String, dynamic> json){
     return Company(
      id: json['id'],
      ruc: json['ruc'],
      razonSocial: json['razon_social'],
      direccion: json['direccion'],
      companyWeb: json['companyWeb']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'ruc': ruc,
      'razon_social': razonSocial,
      'direccion': direccion,
      'companyWeb': companyWeb
    };
  }

  @override
  String toString() {
    return 'Company{id: $id, ruc: $ruc, razon_social: $razonSocial, direccion: $direccion, companyWeb: $companyWeb}';
  }
}
