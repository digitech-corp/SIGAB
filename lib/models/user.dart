class User {
  int? id;
  int? idUsuario;
  int? idTransportista;
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
  double? cuotaMensual;

  User({
    this.id,
    this.idUsuario,
    this.idTransportista,
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
    this.cuotaMensual,
  });

  factory User.fromJSON(Map<String, dynamic> json) {
    double _toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }
    return User(
      id: json['id'],
      idUsuario: json['id_usuario'],
      idTransportista: json['id_transportista'],
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
      cuotaMensual: _toDouble(json['cuota_mensual_soles']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_usuario': idUsuario,
      'id_transportista': idTransportista,
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
    return 'User(id: $id, id_usuario: $idUsuario, id_transportista: $idTransportista, id_tipo_usuario: $idTipoUsuario, id_datos_usuario: $idDatosUsuario, id_sucursal: $idSucursal, habilitar_bajar_precio: $habilitarBajarPrecio, dni: $dni, usuario: $usuario, nombres: $nombres, apellidos: $apellidos, celular: $celular, direccion: $direccion, fecha_nacimiento: $fechaNacimiento, correo: $correo, password: $password, foto_perfil: $fotoPerfil, nombre_tipo_usuario: $nombreTipoUsuario, recordar: $recordar, cuota_mensual_soles: $cuotaMensual)';
  }  

  User copyWith({
    int? idUsuario,
    int? idTipoUsuario,
    int? idTransportista,
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
      idTransportista: idTransportista ?? this.idTransportista,
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
      recordar: recordar ?? this.recordar
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
        "cuota_mensual_soles": cuotaMensual,
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