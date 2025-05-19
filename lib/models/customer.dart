class Customer{
  String customerName;
  String customerImage;
  String customerPhone;
  String customerEmail ;
  String customerAddress; 
  String customerReference; 
  int idCompany;
  int idDepartment;
  int idProvince;
  int idDistrict;
  List<String> customerSteps;

  Customer({
    required this.customerName,
    required this.customerImage,
    required this.customerPhone,
    required this.customerEmail,
    required this.customerAddress,
    required this.customerReference,
    required this.idCompany,
    required this.idDepartment,
    required this.idProvince,
    required this.idDistrict,
    required this.customerSteps
  });

  factory Customer.fromJSON(Map<String, dynamic> json){
    return Customer(
      customerName: json['customerName'],
      customerImage: json['customerImage'],
      customerPhone: json['customerPhone'],
      customerEmail: json['customerEmail'],
      customerAddress: json['customerAddress'],
      customerReference: json['customerReference'],
      idCompany: json['idCompany'] ?? 0,
      idDepartment: json['idDepartment'] ?? 0,
      idProvince: json['idProvince'] ?? 0,
      idDistrict: json['idDistrict'] ?? 0,
      customerSteps: List<String>.from(json['customer']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerName': customerName,
      'customerImage': customerImage,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'customerAddress': customerAddress,
      'customerReference': customerReference,
      'idCompany': idCompany,
      'idDepartment': idDepartment,
      'idProvince': idProvince,
      'idDistrict': idDistrict,
      'customer': customerSteps
    };
  }

  @override
  String toString() {
    return 'Customer{customerName: $customerName, customerImage: $customerImage, customerPhone: $customerPhone, customerEmail: $customerEmail, customerAddress: $customerAddress, customerReference: $customerReference, idCompany: $idCompany, idDepartment: $idDepartment, idProvince: $idProvince, idDistrict: $idDistrict, customer: $customerSteps}';
  }
}