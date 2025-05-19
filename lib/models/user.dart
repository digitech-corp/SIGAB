class User{
  String name;
  String dni;
  String email;
  String password;

  User({
    required this.name,
    required this.dni,
    required this.email,
    required this.password,
  });

  factory User.fromJSON(Map<String, dynamic> json){
    return User(
      name: json['name'],
      dni: json['dni'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dni': dni,
      'email': email,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'User{name: $name, dni: $dni, email: $email, password: $password}';
  }
}