class User {
  int? id;
  int? idUsuario;
  int? idTipoUsuario;
  int? idDatosUsuario;
  int? idSucursal;
  int? habilitarBajarPrecio;
  String? dni;
  String? usuario;
  String nombres;
  String apellidos;
  String? celular;
  String? direccion;
  DateTime? fechaNacimiento;
  String correo;
  String? password;
  String fotoPerfil;
  String? nombreTipoUsuario;
  bool? recordar;

  User({
    this.id,
    this.idUsuario,
    this.idTipoUsuario,
    this.idDatosUsuario,
    this.idSucursal,
    this.habilitarBajarPrecio,
    this.dni,
    this.usuario,
    required this.nombres,
    required this.apellidos,
    this.celular,
    this.direccion,
    this.fechaNacimiento,
    required this.correo,
    this.password,
    required this.fotoPerfil,
    this.nombreTipoUsuario,
    this.recordar = false,
  });

  factory User.fromJSON(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      idUsuario: json['id_usuario'],
      idTipoUsuario: json['id_tipo_usuario'] ?? 0,
      idDatosUsuario: json['id_datos_usuario'],
      idSucursal: json['id_sucursal'],
      habilitarBajarPrecio: json['habilitado_bajar_precio'],
      dni: json['documento'],
      usuario: json['usuario'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      celular: json['celular'],
      direccion: json['direccion'],
      fechaNacimiento: json['fecha_nacimiento'] != null
          ? DateTime.parse(json['fecha_nacimiento'])
          : null,
      correo: json['correo'],
      password: json['password'],
      fotoPerfil: json['foto_perfil'] ?? '',
      nombreTipoUsuario: json['nombre_tipo_usuario'],
      recordar: json['recordar'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_usuario': idUsuario,
      'id_tipo_usuario': idTipoUsuario,
      'id_datos_usuario': idDatosUsuario,
      'id_sucursal': idSucursal,
      'habilitado_bajar_precio': habilitarBajarPrecio,
      'documento': dni,
      'usuario': usuario,
      'nombres': nombres,
      'apellidos': apellidos,
      'celular': celular,
      'direccion': direccion,
      'fecha_nacimiento': fechaNacimiento?.toIso8601String().replaceAll('T', ' '),
      'correo': correo,
      'password': password,
      'foto_perfil': fotoPerfil,
      'nombre_tipo_usuario': nombreTipoUsuario,
      'recordar': recordar ?? false,
    };
  }

  @override
  String toString() {
    return 'User(id: $id, id_usuario: $idUsuario, id_tipo_usuario: $idTipoUsuario, id_datos_usuario: $idDatosUsuario, id_sucursal: $idSucursal, habilitar_bajar_precio: $habilitarBajarPrecio, dni: $dni, usuario: $usuario, nombres: $nombres, apellidos: $apellidos, celular: $celular, direccion: $direccion, fecha_nacimiento: $fechaNacimiento, correo: $correo, password: $password, foto_perfil: $fotoPerfil, nombre_tipo_usuario: $nombreTipoUsuario, recordar: $recordar)';
  }  

  User copyWith({
    int? idUsuario,
    int? idTipoUsuario,
    int? idDatosUsuario,
    int? idSucursal,
    int? habilitarBajarPrecio,
    String? dni,
    String? usuario,
    String? nombres,
    String? apellidos,
    String? celular,
    String? direccion,
    DateTime? fechaNacimiento,
    String? correo,
    String? fotoPerfil,
    String? nombreTipoUsuario,
    bool? recordar = false,
  }) {
    return User(
      idUsuario: idUsuario ?? this.idUsuario,
      idTipoUsuario: idTipoUsuario ?? this.idTipoUsuario,
      idDatosUsuario: idDatosUsuario ?? this.idDatosUsuario,
      idSucursal: idSucursal ?? this.idSucursal,
      habilitarBajarPrecio: habilitarBajarPrecio ?? this.habilitarBajarPrecio,
      dni: dni ?? this.dni,
      usuario: usuario ?? this.usuario,
      nombres: nombres ?? this.nombres,
      apellidos: apellidos ?? this.apellidos,
      celular: celular ?? this.celular,
      direccion: direccion ?? this.direccion,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      correo: correo ?? this.correo,
      fotoPerfil: fotoPerfil ?? this.fotoPerfil,
      nombreTipoUsuario: nombreTipoUsuario ?? this.nombreTipoUsuario,
      recordar: recordar ?? this.recordar,
    );
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      "usuariosGenerales": {
        "id": idUsuario,
        "id_tipo_usuario": idTipoUsuario,
        "id_datos_usuario": idDatosUsuario,
        "id_sucursal": idSucursal,
        "usuario": usuario,
        "password": password,
        "foto_perfil": fotoPerfil,
        "habilitado_bajar_precio": habilitarBajarPrecio,
      },
      "datosUsuarios": {
        "id": idDatosUsuario,
        "nombres": nombres,
        "apellidos": apellidos,
        "correo": correo,
        "celular": celular,
        "direccion": direccion,
        "fecha_nacimiento": fechaNacimiento?.toIso8601String().replaceAll('T', ' '),
      },
    };
  }
}