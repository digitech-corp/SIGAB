class Customer {
  String customerName;
  String customerImage;
  String customerPhone;
  String customerEmail ;
  String customerAddress; 
  String customerReference; 
  int idCompany;

  Customer({
    required this.customerName,
    required this.customerImage,
    required this.customerPhone,
    required this.customerEmail,
    required this.customerAddress,
    required this.customerReference,
    required this.idCompany,
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
    );
  } 
}