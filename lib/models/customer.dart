class Customer {
  int? idCliente;
  int? idTipoCliente;
  int idListaPrecio;
  int estado;
  String? fechaCreado;
  String fotoPerfil;
  String nroDocumento;
  int? idDocumento;
  int? idTipoDocumento;
  String nombres;
  String apellidos;
  String fechaNacimiento;
  String? nombreTipoDoc;
  String? nombreListaPrecio;
  String? label;
  int? value;
  int? idDatosPersona;
  String correo;
  String numero;
  int? idPais;
  int? idUbigeo;
  String? ubigeo;
  String direccion;
  String? referencia;
  int? idCorreo;
  int? idDireccion;
  int? idTelefono;
  int? idDatoGeneral;
  String rucAfiliada;
  String razonSocialAfiliada;
  String direccionAfiliada;

  Customer({
    this.idCliente,
    this.idTipoCliente,
    required this.idListaPrecio,
    required this.estado,
    this.fechaCreado,
    required this.fotoPerfil,
    required this.nroDocumento,
    this.idDocumento,
    this.idTipoDocumento,
    required this.nombres,
    required this.apellidos,
    required this.fechaNacimiento,
    this.nombreTipoDoc,
    this.nombreListaPrecio,
    this.label,
    this.value,
    this.idDatosPersona,
    required this.correo,
    required this.numero,
    this.idPais,
    this.idUbigeo,
    this.ubigeo,
    required this.direccion,
    this.referencia = '',
    this.idCorreo,
    this.idDireccion,
    this.idTelefono,
    this.idDatoGeneral,
    required this.rucAfiliada,
    required this.razonSocialAfiliada,
    required this.direccionAfiliada,
  });

  factory Customer.fromJSON(Map<String, dynamic> json) {
    return Customer(
      idCliente: json['id_cliente'],
      idTipoCliente: json['id_tipo_cliente'],
      idListaPrecio: json['id_lista_precio'],
      estado: json['estado'],
      fechaCreado: json['fecha_creado'],
      fotoPerfil: json['foto_perfil'] ?? '',
      nroDocumento: json['nro_documento'],
      idDocumento: json['id_documento'],
      idTipoDocumento: json['id_tipo_documento'], //nuevo
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      fechaNacimiento: json['fecha_nacimiento'],
      nombreTipoDoc: json['nombre_tipo_doc'],
      nombreListaPrecio: json['nombre_lista_precio'],
      label: json['label'],
      value: json['value'],
      idDatosPersona: json['id_datos_persona'],
      correo: json['correo'] ?? '',
      numero: json['numero'] ?? '',
      // idPais: json['id_pais'] ?? '', //nuevo
      idUbigeo: json['id_ubigeo'] ?? 0,
      ubigeo: json['ubigeo'] ?? '',
      direccion: json['direccion'] ?? '',
      referencia: json['referencia'] ?? '',
      idCorreo: json['id_correo'],
      idDireccion: json['id_direccion'],
      idTelefono: json['id_telefono'],
      idDatoGeneral: json['id_dato_general'],
      rucAfiliada: json['ruc_afiliada'] ?? '',
      razonSocialAfiliada: json['razon_social_afiliada'] ?? '',
      direccionAfiliada: json['direccion_afiliada'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_cliente': idCliente,
      'id_tipo_cliente': idTipoCliente,
      'id_lista_precio': idListaPrecio,
      'estado': estado,
      'fecha_creado': fechaCreado,
      'foto_perfil': fotoPerfil,
      'nro_documento': nroDocumento,
      'id_documento': idDocumento,
      'id_tipo_documento': idTipoDocumento,
      'nombres': nombres,
      'apellidos': apellidos,
      'fecha_nacimiento': fechaNacimiento,
      'nombre_tipo_doc': nombreTipoDoc,
      'nombre_lista_precio': nombreListaPrecio,
      'label': label,
      'value': value,
      'id_datos_persona': idDatosPersona,
      'id_pais': idPais,
      'correo': correo,
      'numero': numero,
      'id_ubigeo': idUbigeo,
      'ubigeo': ubigeo,
      'direccion': direccion,
      'referencia': referencia,
      'id_correo': idCorreo,
      'id_direccion': idDireccion,
      'id_telefono': idTelefono,
      'id_dato_general': idDatoGeneral,
      'ruc_afiliada': rucAfiliada,
      'razon_social_afiliada': razonSocialAfiliada,
      'direccion_afiliada': direccionAfiliada,
    };
  }

  @override
  String toString() {
    return 'Customer{id_cliente: $idCliente, id_tipo_cliente: $idTipoCliente, id_lista_precio: $idListaPrecio, estado: $estado, fecha_creado: $fechaCreado, foto_perfil: $fotoPerfil, nro_documento: $nroDocumento, id_documento: $idDocumento, id_tipo_documento: $idTipoDocumento, nombres: $nombres, apellidos: $apellidos, fecha_nacimiento: $fechaNacimiento, nombre_tipo_doc: $nombreTipoDoc, nombre_lista_precio: $nombreListaPrecio, label: $label, value: $value, id_datos_persona: $idDatosPersona, correo: $correo, numero: $numero, id_pais: $idPais, id_ubigeo: $idUbigeo, ubigeo: $ubigeo, direccion: $direccion, referencia: $referencia, id_correo: $idCorreo, id_direccion: $idDireccion, id_telefono: $idTelefono, id_dato_general: $idDatoGeneral, ruc_afiliada: $rucAfiliada, razon_social_afiliada: $razonSocialAfiliada, direccion_afiliada: $direccionAfiliada}';
  }

  Customer copyWith({
    int? idCliente,
    int? idTipoCliente,
    int? idListaPrecio,
    int? estado,
    String? fechaCreado,
    String? fotoPerfil,
    String? nroDocumento,
    int? idDocumento,
    int? idTipoDocumento,
    String? nombres,
    String? apellidos,
    String? fechaNacimiento,
    String? nombreTipoDoc,
    String? nombreListaPrecio,
    String? label,
    int? value,
    int? idDatosPersona,
    String? correo,
    String? numero,
    int? idPais,
    int? idUbigeo,
    String? ubigeo,
    String? direccion,
    String? referencia,
    int? idCorreo,
    int? idDireccion,
    int? idTelefono,
    int? idDatoGeneral,
    String? rucAfiliada,
    String? razonSocialAfiliada,
    String? direccionAfiliada,
  }) {
    return Customer(
      idCliente: idCliente ?? this.idCliente,
      idListaPrecio: idListaPrecio ?? this.idListaPrecio,
      estado: estado ?? this.estado,
      fechaCreado: fechaCreado ?? this.fechaCreado,
      fotoPerfil: fotoPerfil ?? this.fotoPerfil,
      nroDocumento: nroDocumento ?? this.nroDocumento,
      idDocumento: idDocumento ?? this.idDocumento,
      idTipoDocumento: idTipoDocumento ?? this.idTipoDocumento,
      nombres: nombres ?? this.nombres,
      apellidos: apellidos ?? this.apellidos,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      nombreTipoDoc: nombreTipoDoc ?? this.nombreTipoDoc,
      nombreListaPrecio: nombreListaPrecio ?? this.nombreListaPrecio,
      label: label ?? this.label,
      value: value ?? this.value,
      idDatosPersona: idDatosPersona ?? this.idDatosPersona,
      correo: correo ?? this.correo,
      numero: numero ?? this.numero,
      idPais: idPais ?? this.idPais,
      idUbigeo: idUbigeo ?? this.idUbigeo,
      ubigeo: ubigeo ?? this.ubigeo,
      direccion: direccion ?? this.direccion,
      referencia: referencia ?? this.referencia,
      idCorreo: idCorreo ?? this.idCorreo,
      idDireccion: idDireccion ?? this.idDireccion,
      idTelefono: idTelefono ?? this.idTelefono,
      idDatoGeneral: idDatoGeneral ?? this.idDatoGeneral,
      rucAfiliada: rucAfiliada ?? this.rucAfiliada,
      razonSocialAfiliada: razonSocialAfiliada ?? this.razonSocialAfiliada,
      direccionAfiliada: direccionAfiliada ?? this.direccionAfiliada,
    );
  }


  Map<String, dynamic> toApiRequest() {
    return {
      "cliente": {
        "id": idCliente,
        "id_tipo_cliente": idTipoCliente,
        "id_lista_precio": idListaPrecio,
        "foto_perfil": fotoPerfil,
        "estado": estado,
      },
      "empresaAfiliada": {
        "ruc": rucAfiliada,
        "razon_social": razonSocialAfiliada,
        "direccion": direccionAfiliada,
      },
      "datosGenerales": {
        "id_tipo_documento": idTipoDocumento,
        "numero_documento": nroDocumento,
        "estado": estado,
      },
      "datosPersonas": {
        "nombres": nombres,
        "apellidos": apellidos,
        "fecha_nacimiento": fechaNacimiento,
      },
      "direcciones": {
        "id_pais": idPais,
        "id_ubigeo": idUbigeo?.toString(),
        "direccion": direccion,
        "referencia": referencia,
      },
      "correos": {
        "correo": correo,
      },
      "numeros_telefonicos": {
        "numero": numero,
      }
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'cliente': {
        'id': idCliente,
        'id_tipo_cliente': idTipoCliente,
        'id_datos_generales': idDatoGeneral,
        'id_lista_precio': idListaPrecio,
        'estado': estado,
        'foto_perfil': fotoPerfil,
      },
      'empresaAfiliada': {
        'ruc': rucAfiliada,
        'razon_social': razonSocialAfiliada,
        'direccion': direccionAfiliada,
      },
      'datosGenerales': {
        'id': idDatoGeneral,
        'id_tipo_documento': idDocumento,
        'numero_documento': nroDocumento,
        'estado': estado,
      },
      'datosPersonas': {
        'id': idDatosPersona,
        'id_datos_generales': idDatoGeneral,
        'nombres': nombres,
        'apellidos': apellidos,
        'fecha_nacimiento': fechaNacimiento,
      },
      'direcciones': {
        'id': idDireccion,
        'id_pais': idPais,
        'id_ubigeo': idUbigeo,
        'direccion': direccion,
        'referencia': referencia,
      },
      'correos': {
        'id': idCorreo,
        'correo': correo,
      },
      'numeros_telefonicos': {
        'id': idTelefono,
        'numero': numero,
      }
    };
  }
}