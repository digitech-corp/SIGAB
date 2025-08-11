import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class FacturasProvider extends ChangeNotifier {
  bool isLoading = false;

  Future<void> generarTicket(String token, int idOrder) async {
    isLoading = true;
    notifyListeners();
    try {
      final url = Uri.parse('https://adysabackend.facturador.es/pedidosTicket/documento/$idOrder/1');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Uint8List bytes = response.bodyBytes;
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/ticket_$idOrder.pdf');
        await file.writeAsBytes(bytes);

        await OpenFile.open(file.path);
      } else {
        print('Error HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción al generar ticket: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
