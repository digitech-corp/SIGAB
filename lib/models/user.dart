class User{
  String name;
  String dni;
  String email;
  String password;
  final String? image;
  String role;

  User({
    required this.name,
    required this.dni,
    required this.email,
    required this.password,
    this.image,
    required this.role,
  });

  factory User.fromJSON(Map<String, dynamic> json){
    return User(
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
    return 'User{name: $name, dni: $dni, email: $email, password: $password, image: $image, role: $role}';
  }
}