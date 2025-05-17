class Company {
  int idCompany;
  String companyName;
  String companyRUC;
  String companyAddress;

  Company({
    required this.idCompany,
    required this.companyName,
    required this.companyRUC,
    required this.companyAddress,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      idCompany: int.tryParse(json['idCompany'].toString()) ?? 0,
      companyName: (json['companyName'] ?? '').toString(),
      companyRUC: (json['companyRUC'] ?? '').toString(),
      companyAddress: (json['companyAddress'] ?? '').toString(),
    );
  } 
}