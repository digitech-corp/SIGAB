class Province{
  int idProvince;
  String province;
  int idDepartment;

  Province({
    required this.idProvince,
    required this.province,
    required this.idDepartment
  });

  factory Province.fromJSON(Map<String, dynamic> json){
     return Province(
      idProvince: json['idProvince']?? 0,
      province: json['province'],
      idDepartment: json['idDepartment']?? 0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProvince': idProvince,
      'province': province,
      'idDepartment': idDepartment
    };
  }

  @override
  String toString() {
    return 'Province{idProvince: $idProvince, province: $province, idDepartment: $idDepartment}';
  }
}
