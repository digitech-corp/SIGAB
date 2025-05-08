import 'package:balanced_foods/screens/sales_module_screen.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SalesModuleScreen()),
                      );
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Dashboard',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              Text(
                'Panel de Ventas',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),

              SizedBox(height: 20),
              VentasTotalesCard(),

              SizedBox(height: 20),
              Text(
                'Couta de Ventas y Progreso',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),

              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _cuotaCuentaCard('Cuota Mensual', 'S/20,000.00'),
                  ),
                  SizedBox(width: 3),
                  Expanded(
                    child: _progresoCard('Progreso actual', '75%', 'S/15,000.00'),
                  ),
                ],
              ),

              SizedBox(height: 20),
              Text(
                'Cuentas y Pedidos',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),

              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _cuotaCuentaCard('Créditos por Cobrar', 'S/5,600.00'),
                  ),
                  SizedBox(width: 3),
                  Expanded(
                    child: _pedidoCard('Pedidos por entregar', '7', 'Pedidos pendientes'),
                  ),
                ],
              ),

              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _cuotaCuentaCard(
    String title,
    String cash,
    ) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 100,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                color: Color(0xFFFF6600),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 8),
            Text(
              cash,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                color: Color(0xFF333333),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _progresoCard(
    String title,
    String porcentage,
    String cash,
    ) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 100,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                color: Color(0xFFFF6600),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 8),
            Text(
              porcentage,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                color: Color(0xFF2ECC71),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 8),
            Text(
              cash,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 10,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pedidoCard(
    String title,
    String quantity,
    String subtitle,
    ) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 100,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                color: Color(0xFFFF6600),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 8),
            Text(
              quantity,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                color: Color(0xFFE74C3C),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 10,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VentasTotalesCard extends StatefulWidget {
  @override
  _VentasTotalesCardState createState() => _VentasTotalesCardState();
}

class _VentasTotalesCardState extends State<VentasTotalesCard> {
  int _selectedIndex = 0;
  final List<String> _titulos = ['Diario', 'Semanal', 'Mensual'];

  TextStyle _textStyle() {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFF333333),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 270,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header con botones
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_titulos.length, (index) {
                final bool isSelected = _selectedIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Color(0xFFECEFF1),
                      borderRadius: BorderRadius.circular(10),
                      border: isSelected
                          ? Border.all(color: Color(0xFFFF6600), width: 2)
                          : null,
                    ),
                    child: Text(
                      _titulos[index],
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: isSelected ? Color(0xFFFF6600) : Color(0xFF333333),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          // Contenido del gráfico (dinámico)
          Expanded(
            child: Center(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  Text('Gráfico Diario', style: _textStyle()),
                  Text('Gráfico Semanal', style: _textStyle()),
                  Text('Gráfico Mensual', style: _textStyle()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



