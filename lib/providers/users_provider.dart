import 'dart:convert';
import 'package:balanced_foods/models/user.dart';
import 'package:balanced_foods/providers/AppSettingsProvider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class UsersProvider extends ChangeNotifier{
  final AppSettingsProvider settingsProvider;
  UsersProvider({required this.settingsProvider});
  bool get useLocalData => settingsProvider.useLocalData;
  
  bool isLoading = false;
  List<User> users= [];
  

  User? _loggedUser;
  User? get loggedUser => _loggedUser;
  
  Future<void> fetchUsers() async {
    isLoading = true; 
    notifyListeners();

    try {
      if (useLocalData) {
        final data = await loadJsonFromAssets('assets/datos/users.json');
        users = List<User>.from(data['users'].map((user) => User.fromJSON(user)));
      } else {
        final url = Uri.parse('http://10.0.2.2:12346/users');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          users = List<User>.from(data['users'].map((user) => User.fromJSON(user)));
        } else {
          print('Error ${response.statusCode}');
          users = [];
        }
      }
    } catch (e) {
      print('Error: $e');
      users = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<User?> validateUser(String email, String password) async {
    try {
      Map<String, dynamic> data;
      if (useLocalData) {
        data = await loadJsonFromAssets('assets/datos/users.json');
      } else {
        final url = Uri.parse('http://10.0.2.2:12346/users');
        final response = await http.get(url);
        if (response.statusCode != 200) return null;
        data = jsonDecode(response.body);
      }

      final List<dynamic> jsonUsers = data['users'];

      for (final user in jsonUsers) {
        if (user['email'] == email && user['password'] == password) {
          _loggedUser = User.fromJSON(user);
          notifyListeners();
          return _loggedUser;
        }
      }
    } catch (e) {
      print('Error validando usuario: $e');
    }
    return null;
  }

  void logout() {
    _loggedUser = null;
    notifyListeners();
  }
  
  Future<bool> registerUser(User user) async {
    if (useLocalData) {
      print('Modo de prueba: No se puede registrar un usuario en un archivo local.');
      return false;
    }
    final url = Uri.parse('http://10.0.2.2:12346/users');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );
      
      if (response.statusCode == 201) {
        await fetchUsers();
        return true;
        
      } else {
        print('Error al registrar: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<String> recoverPassword(String email) async {
    final url = Uri.parse('http://10.0.2.2:12346/recover');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'] ?? 'Revisa tu correo electrónico.';
      } else {
        return 'Error al procesar la solicitud.';
      }
    } catch (e) {
      return 'Ocurrió un error. Intenta nuevamente.';
    }
  }

  // CARGAR DATOS
  Future<Map<String, dynamic>> loadJsonFromAssets(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return json.decode(jsonString);
  }
}