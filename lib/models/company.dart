class Company{
  int idCompany;
  String companyName;
  String companyRUC;
  String companyAddress;
  List<String> companiesSteps;

  Company({
    required this.idCompany,
    required this.companyName,
    required this.companyRUC,
    required this.companyAddress,
    required this.companiesSteps
  });

  factory Company.fromJSON(Map<String, dynamic> json){
     return Company(
      idCompany: json['idCompany']?? 0,
      companyName: json['companyName'],
      companyRUC: json['companyRUC'],
      companyAddress: json['companyAddress'],
      companiesSteps: List<String>.from(json['company']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCompany': idCompany,
      'companyName': companyName,
      'companyRUC': companyRUC,
      'companyAddress': companyAddress,
      'company': companiesSteps
    };
  }

  @override
  String toString() {
    return 'Company{idCompany: $idCompany, companyName: $companyName, companyRUC: $companyRUC, companyAddress: $companyAddress, company: $companiesSteps}';
  }
}
