class District{
  int idDistrict;
  String district;

  District({
    required this.idDistrict,
    required this.district
  });

  factory District.fromJSON(Map<String, dynamic> json){
     return District(
      idDistrict: json['id'] ?? 0,
      district: json['distrito']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': idDistrict,
      'distrito': district
    };
  }

  @override
  String toString() {
    return 'District{id: $idDistrict, distrito: $district}';
  }
}
