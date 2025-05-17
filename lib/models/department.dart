class Department {
  int idDepartment;
  String department;

  Department({
    required this.idDepartment,
    required this.department,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      idDepartment: int.tryParse(json['idDepartment'].toString()) ?? 0,
      department: (json['department'] ?? '').toString(),
    );
  } 
}