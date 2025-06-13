class User{
  int? idUser;
  String name;
  String dni;
  String email;
  String password;
  final String? image;
  String role;

  User({
    this.idUser,
    required this.name,
    required this.dni,
    required this.email,
    required this.password,
    this.image,
    required this.role,
  });

  factory User.fromJSON(Map<String, dynamic> json){
    return User(
      idUser: json['idUser'],
      name: json['name'],
      dni: json['dni'],
      email: json['email'],
      password: json['password'],
      image: json['image'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'name': name,
      'dni': dni,
      'email': email,
      'password': password,
      'image': image,
      'role': role,
    };
  }

  @override
  String toString() {
    return 'User{idUser: $idUser, name: $name, dni: $dni, email: $email, password: $password, image: $image, role: $role}';
  }
}