import 'dart:convert';
import 'package:balanced_foods/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UsersProvider extends ChangeNotifier{
  bool isLoading = false;
  List<User> users= [];
  
  Future<void> fetchUsers() async {
    isLoading = true;
    notifyListeners();
    final usersUrl = Uri.parse('http://10.0.2.2:12346/users');
    try {
      final usersResponse = await http.get(usersUrl);
      if (usersResponse.statusCode == 200) {
        final usersData = jsonDecode(usersResponse.body);
        users = List<User>.from(usersData.map((user) => User.fromJSON(user)));
      } else {
        print('Error ${usersResponse.statusCode}');
        users = [];
      }
    } catch (e) {
      print('Error: $e');
      users = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> validateUser(String email, String password) async {
    final url = Uri.parse('http://10.0.2.2:12346/users');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('Respuesta status: ${response.statusCode}');
      print('Body recibido: ${response.body}');
      final decoded = jsonDecode(response.body);
      print('Tipo: ${decoded.runtimeType}');

      final List<dynamic> usersList = decoded['users'];

      for (final user in usersList) {
        if (user['email'] == email && user['password'] == password) {
          return true;
        }
      }
    }

    return false;
  }

  
  Future<bool> registerUser(User user) async {
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
}