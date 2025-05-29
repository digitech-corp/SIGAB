class Department{
  int idDepartment;
  String department;

  Department({
    required this.idDepartment,
    required this.department
  });

  factory Department.fromJSON(Map<String, dynamic> json){
     return Department(
      idDepartment: json['idDepartment']?? 0,
      department: json['department']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idDepartment': idDepartment,
      'department': department
    };
  }

  @override
  String toString() {
    return 'Department{idDepartment: $idDepartment, department: $department}';
  }
}
