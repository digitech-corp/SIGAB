class District {
  int idDistrict;
  String district;
  int idProvince;

  District({
    required this.idDistrict,
    required this.district,
    required this.idProvince,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      idDistrict: int.tryParse(json['idDistrict'].toString()) ?? 0,
      district: (json['district'] ?? '').toString(),
      idProvince: int.tryParse(json['idProvince'].toString()) ?? 0,
    );
  } 
}