class District{
  int idDistrict;
  String district;
  int idProvince;

  District({
    required this.idDistrict,
    required this.district,
    required this.idProvince
  });

  factory District.fromJSON(Map<String, dynamic> json){
     return District(
      idDistrict: json['idDistrict']?? 0,
      district: json['district'],
      idProvince: json['idProvince']?? 0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCompany': idDistrict,
      'companyName': district,
      'idProvince': idProvince
    };
  }

  @override
  String toString() {
    return 'district{idDistrict: $idDistrict, district: $district, idProvince: $idProvince}';
  }
}
