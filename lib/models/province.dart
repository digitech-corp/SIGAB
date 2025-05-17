class Province {
  int idProvince;
  String province;
  int idDepartment;

  Province({
    required this.idProvince,
    required this.province,
    required this.idDepartment,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      idProvince: int.tryParse(json['idProvince'].toString()) ?? 0,
      province: (json['province'] ?? '').toString(),
      idDepartment: int.tryParse(json['idDepartment'].toString()) ?? 0,
    );
  } 
}