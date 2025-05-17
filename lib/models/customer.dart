class Customer {
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
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerName: (json['customerName'] ?? '').toString().trim(),
      customerImage: (json['customerImage'] ?? '').toString(),
      customerPhone: (json['customerPhone'] ?? '').toString(),
      customerEmail: (json['customerEmail'] ?? '').toString(),
      customerAddress: (json['customerAddress'] ?? '').toString(),
      customerReference: (json['customerReference'] ?? '').toString(),
      idCompany: int.tryParse(json['idCompany'].toString()) ?? 0,
      idDepartment: int.tryParse(json['idDepartment'].toString()) ?? 0,
      idProvince: int.tryParse(json['idProvince'].toString()) ?? 0,
      idDistrict: int.tryParse(json['idDistrict'].toString()) ?? 0,
    );
  } 
}