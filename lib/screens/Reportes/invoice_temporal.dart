import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> enviarFacturaPorWhatsApp({
  required BuildContext context,
  required String phoneNumber,
  required String facturaTexto,
  required List<int> pdfBytes,
}) async {
  try {
    // Guardar el PDF en un archivo temporal
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/factura.pdf');
    await file.writeAsBytes(pdfBytes);

    // Usar share_plus para compartir directamente a WhatsApp
    await Share.shareXFiles(
      [XFile(file.path)],
      text: facturaTexto,
      sharePositionOrigin: Rect.zero,
    );

  } catch (e) {
    debugPrint('Error al enviar WhatsApp: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se pudo enviar la factura por WhatsApp')),
    );
  }
}
