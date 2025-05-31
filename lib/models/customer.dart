class Customer{
  int? idCustomer;
  String customerName;
  String dni;
  String customerImage;
  String customerPhone;
  String customerEmail ;
  String customerAddress; 
  String customerReference; 
  int idCompany;
  int idDepartment;
  int idProvince;
  int idDistrict;

  Customer({
    this.idCustomer,
    required this.customerName,
    required this.dni,
    required this.customerImage,
    required this.customerPhone,
    required this.customerEmail,
    required this.customerAddress,
    required this.customerReference,
    required this.idCompany,
    required this.idDepartment,
    required this.idProvince,
    required this.idDistrict
  });

  factory Customer.fromJSON(Map<String, dynamic> json){
    return Customer(
      idCustomer: json['idCustomer'],
      customerName: json['customerName'],
      dni: json['dni'] ?? '',
      customerImage: json['customerImage'],
      customerPhone: json['customerPhone'],
      customerEmail: json['customerEmail'],
      customerAddress: json['customerAddress'],
      customerReference: json['customerReference'],
      idCompany: json['idCompany'] ?? 0,
      idDepartment: json['idDepartment'] ?? 0,
      idProvince: json['idProvince'] ?? 0,
      idDistrict: json['idDistrict'] ?? 0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCustomer': idCustomer,
      'customerName': customerName,
      'dni': dni,
      'customerImage': customerImage,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'customerAddress': customerAddress,
      'customerReference': customerReference,
      'idCompany': idCompany,
      'idDepartment': idDepartment,
      'idProvince': idProvince,
      'idDistrict': idDistrict
    };
  }

  @override
  String toString() {
    return 'Customer{idCustomer: $idCustomer, customerName: $customerName, dni: $dni, customerImage: $customerImage, customerPhone: $customerPhone, customerEmail: $customerEmail, customerAddress: $customerAddress, customerReference: $customerReference, idCompany: $idCompany, idDepartment: $idDepartment, idProvince: $idProvince, idDistrict: $idDistrict}';
  }
}