import 'dart:convert';
import 'package:balanced_foods/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UsersProvider extends ChangeNotifier {
  bool isLoading = false;
  List<User> users = [];
  User? _loggedUser;
  String? _token;

  User? get loggedUser => _loggedUser;
  String? get token => _token;

  void setLoggedUser(User user) {
    _loggedUser = user;
    notifyListeners();
  }

  Future<int?> login(String usuario, String password) async {
    final url = Uri.parse('https://adysabackend.facturador.es/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'usuario': usuario,
        'password': password,
        'recordar': 'true',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['exito'] == true && data['token'] != null) {
        _token = data['token'];
        final idUsuario = data['data']['id'];
        final idTransportista = data['data']['id_transportista'];
        await fetchLoggedUserData(idUsuario, idTransportista);
        return data['id_tipo_usuario'];
      }
    }
    return null;
  }

  Future<void> fetchLoggedUserData(int idUsuario, int? idTransportista) async {
    isLoading = true;
    notifyListeners();
    try {
      final url = Uri.parse('https://adysabackend.facturador.es/users/getUsers');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      });

      if (response.statusCode == 200) {
        final List<dynamic> dataList = jsonDecode(response.body);
        Map<String, dynamic>? userMap;
        try {
          userMap = dataList.firstWhere((user) => user['id_usuario'] == idUsuario);
        } catch (_) {
          userMap = null;
        }

        if (userMap != null) {
          _loggedUser = User.fromJSON(userMap);
          _loggedUser?.idTransportista = idTransportista;
        } else {
          print('Usuario no encontrado en la lista');
        }
        notifyListeners();
      } else {
        print('Error ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> recoverPassword(String email) async {
    final url = Uri.parse('https://adysabackend.facturador.es/auth/enviarCodigoCorreo');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final bool responseState = data['response'] == true;
        final String message = data['message'] ?? 'Verifique su correo';
        
        return {'response': responseState, 'message': message};
      } else {
        return {'response': false, 'message': 'Error al procesar la solicitud.'};
      }
    } catch (e) {
      return {'response': false, 'message': 'Ocurrió un error. Intenta nuevamente.'};
    }
  }

  Future<String> setNewPassword(String email, String code, String newPassword) async {
    final url = Uri.parse('https://adysabackend.facturador.es/auth/actualizarContrasena');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'code': code,
          'newPassword': newPassword,
        }),
      );
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'] ?? 'Contraseña restablecida';
      } else {
        return 'Error al procesar la solicitud.';
      }
    } catch (e) {
      return 'Ocurrió un error. Intenta nuevamente.';
    }
  }
  
  void logout() {
    _loggedUser = null;
    _token = null;
    notifyListeners();
  }

  Future<bool> updateUser(Map<String, dynamic> cuerpo, String token) async {
    try {
      final response = await http.put(
        Uri.parse('https://adysabackend.facturador.es/users/updateUser'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(cuerpo),
      );
      if (response.statusCode == 200) {
        fetchLoggedUserData(_loggedUser?.idUsuario ?? 0, _loggedUser?.idTransportista ?? 0);
        return true;
      } else {
        throw Exception('Error al actualizar el usuario: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
