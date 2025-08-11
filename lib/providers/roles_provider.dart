import 'dart:convert';
import 'package:balanced_foods/models/rol.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RolesProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Rol> roles = [];

  Future<void> fetchRoles(String token) async {
      isLoading = true;
      notifyListeners();
      try {
        final url = Uri.parse('https://adysabackend.facturador.es/tiposUsuarios/getTiposUsuarios');
        final response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          roles = data.map((rolJson) => Rol.fromJSON(rolJson)).toList();
        } else {
          print('Error ${response.statusCode}');
          roles = [];
        }
      } catch (e) {
        print('Error: $e');
        roles = [];
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
}