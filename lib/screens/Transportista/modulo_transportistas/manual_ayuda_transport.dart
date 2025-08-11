import 'package:flutter/material.dart';

class ManualAyudaPageTransportista extends StatelessWidget {
  const ManualAyudaPageTransportista({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xFFFF6600); // Verde oscuro
    final Color secondaryColor = Color(0xFFECEFF1); // Gris claro
    final TextStyle titleStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: primaryColor,
    );
    final TextStyle bodyStyle = TextStyle(
      fontSize: 16,
      color: Colors.black87,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual de Ayuda'),
        backgroundColor: primaryColor,
      ),
      body: Container(
        color: secondaryColor,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text("📘 Manual de Usuario", style: titleStyle),
            Text("Sistema Integral de Gestión de Alimentos Balanceados\nVersión: 1.0\n", style: bodyStyle),
            _buildSection("1. Introducción", "La aplicación Gestión de Alimentos Balanceados es una herramienta móvil diseñada para vendedores, administradores y transportistas de la empresa, con el fin de facilitar la formulación, control y seguimiento de pedidos de productos."),
            _buildSection("2. Requisitos del sistema", "• Android: Versión 9.0 o superior.\n• Conexión a Internet requerida\n• 100 MB de almacenamiento libre"),
            _buildSection("3. Instalación y acceso", "1. Descargue desde Google Play.\n2. Inicie sesión con sus credenciales generados por el sistema web de la empresa.\n3. Cambie contraseña de usuario en caso sea olvidada.\n4. Ingrese al panel principal."),
            _buildSection("4. Panel principal", "Visualice accesos rápidos a los módulos como gráficos estadísticos, entregas pendientes y entregas terminadas."),
            _buildSection("5. Módulo de entregas pendientes", "• Visualice las entregas pendientes por prioridad.\n• Mencione opcionalmente incidencias.\n• Registre su firma digital del cliente.\n• Adjunte imagenes de prueba de la entrega.\n• Sincronización automática con la nube."),
            _buildSection("6. Módulo de entregas terminadas", "• Visualice las entregas terminadas.\n• Filtre por cliente y/o por fecha.\n• Seleccione la entrega para ver detalles.\n• Sincronización automática con la nube."),
            _buildSection("7. Gráficos", "• Visualice gráficos estadísticos con datos diarios, semanales y mensuales.\n• Ver total de pedidos realizados, créditos y dinero .\n• Ver créditos pendientes.\n• Sincronización automática con la nube."),
            _buildSection("8. Configuración de la cuenta", "• Modifique sus datos personales.\n• Modifique su foto de perfil."),
            _buildSection("9. Soporte técnico", "📧 soporte@alimentosapp.com\n📞 +34 900 123 456\n🌐 www.alimentosapp.com/soporte\nHorario: Lun–Vie 9:00 a 17:00 (UTC -5)"),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(content, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
