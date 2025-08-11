class Department{
  String department;

  Department({
    required this.department
  });

  factory Department.fromJSON(Map<String, dynamic> json){
     return Department(
      department: json['departamento']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'departamento': department
    };
  }

  @override
  String toString() {
    return 'Department{departamento: $department}';
  }
}
