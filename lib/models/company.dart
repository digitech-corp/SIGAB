class Company{
  int? idCompany;
  String companyName;
  String companyRUC;
  String companyAddress;
  String companyWeb;

  Company({
    this.idCompany,
    required this.companyName,
    required this.companyRUC,
    required this.companyAddress,
    required this.companyWeb
  });

  factory Company.fromJSON(Map<String, dynamic> json){
     return Company(
      idCompany: json['idCompany'],
      companyName: json['companyName'],
      companyRUC: json['companyRUC'],
      companyAddress: json['companyAddress'],
      companyWeb: json['companyWeb']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idCompany != null) 'idCompany': idCompany,
      'companyName': companyName,
      'companyRUC': companyRUC,
      'companyAddress': companyAddress,
      'companyWeb': companyWeb
    };
  }

  @override
  String toString() {
    return 'Company{idCompany: $idCompany, companyName: $companyName, companyRUC: $companyRUC, companyAddress: $companyAddress, companyWeb: $companyWeb}';
  }
}
