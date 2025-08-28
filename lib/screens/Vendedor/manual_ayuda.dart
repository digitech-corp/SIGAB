import 'package:flutter/material.dart';

class ManualAyudaPage extends StatelessWidget {
  const ManualAyudaPage({Key? key}) : super(key: key);

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
            _buildSection("1. Introducción", "La aplicación Gestión de Alimentos Balanceados es una herramienta móvil diseñada para vendedores y transportistas de la empresa, con el fin de facilitar la formulación, control y seguimiento de pedidos de productos."),
            _buildSection("2. Requisitos del sistema", "• Android: Versión 9.0 o superior.\n• Conexión a Internet requerida"),
            _buildSection("3. Instalación y acceso", "1. Descargue desde Google Play.\n2. Inicie sesión con sus credenciales generados por el sistema web de la empresa.\n3. Cambie contraseña de usuario en caso sea olvidada.\n4. Ingrese al panel principal."),
            _buildSection("4. Panel principal", "Visualice accesos rápidos a los módulos como gráficos estadísticos, clientes, pedidos, seguimientos y facturación."),
            _buildSection("5. Módulo de clientes", "• Agregue clientes con empresa afiliada.\n• Edite clientes existentes.\n• Ver datos históricos de clientes.\n• Comparta factura con el cliente.\n• Sincronización automática con la nube."),
            _buildSection("6. Módulo de pedidos", "• Visualice los pedidos registrados filtrados por fecha.\n• Presione en un pedido amarillo para editarlo.\nRegistre pedidos para clientes.\n1. Seleccione al cliente desde el buscador.\n2. Seleccione productos del catálogo o directamente del buscador.\n3. Seleccione tipo de recibo.\n4. Seleccione tipo de pago y registre datos de pago.\n5. ingrese opcionalmente información adicional del pedido.\n6. Visualización de resumen de pedido que se esta realizando.\n• Sincronización automática con la nube."),
            _buildSection("7. Módulo de seguimiento de pedidos", "• Visualice el estado de pedidos y detalles de entrega.\n• Aplique filtro por fecha.\n• Sincronización automática con la nube."),
            _buildSection("8. Módulo de cobranzas", "• Visualice estado de vencimiento de créditos de clientes.\n• Aplique filtro por fecha.\n• Genere ticket de pedidos de clientes.\n• Sincronización automática con la nube."),
            _buildSection("9. Gráficos", "• Visualice gráficos estadísticos.\n• Ver total de ventas realizadas con costos y sacos.\n• Ver total de créditos de usuario y progreso\n• Ver créditos pendientes.\n• Aplique filtro diario, semanal o mensual de los datos.\n• Sincronización automática con la nube."),
            _buildSection("10. Configuración de la cuenta", "• Modifique sus datos personales.\n• Modifique su foto de perfil."),
            _buildSection("11. Soporte técnico", "📧 soporte@digitech-corp.pe\n📞 +51 989 975 369\n🌐 Https://digitech-corp.pe/contacto\nHorario: Lun–Sab 8:00 a 18:00 (UTC -5)"),
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
