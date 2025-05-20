import 'dart:convert';
import 'package:balanced_foods/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UsersProvider extends ChangeNotifier{
  bool isLoading = false;
  List<User> users= [];

  User? _loggedUser;
  User? get loggedUser => _loggedUser;
  
  Future<void> fetchUsers() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.parse('http://10.0.2.2:12346/users');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        users = List<User>.from(data.map((user) => User.fromJSON(user)));
      } else {
        print('Error ${response.statusCode}');
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

  Future<User?> validateUser(String email, String password) async {
    final url = Uri.parse('http://10.0.2.2:12346/users');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> users = decoded['users'];
      for (final user in users) {
        if (user['email'] == email && user['password'] == password) {
          _loggedUser = User.fromJSON(user);
          notifyListeners();
          return _loggedUser;
        }
      }
    }
    return null;
  }

  void logout() {
    _loggedUser = null;
    notifyListeners();
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