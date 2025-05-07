import 'package:flutter/material.dart';
import 'package:balanced_foods/screens/login_screen.dart';

class SalesModuleScreen extends StatelessWidget {
  SalesModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF6600),
      drawer: _buildDrawer(context),
      body: Column(
        children: [
          SizedBox(height: 60),
          //User
          Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(
                    builder: (context) {
                      return GestureDetector(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          child: Image(
                            image: AssetImage('assets/images/user.jpg'),
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Hola'+' {name}',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    'Bienvenida a tu panel de trabajo',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 35),
          //Modules
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildCard('Dashboard', 'barchart')),
                    SizedBox(width: 3),
                    Expanded(child: _buildCard('Pedidos', 'shop', '5 Registros')),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildCard('Clientes', 'customer', '35 Registros')),
                    SizedBox(width: 3),
                    Expanded(child: _buildCard('Seguimiento', 'follow', '3 Registros')),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildCard('Cobranzas', 'salary', '4 Pendientes')),
                    Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          items: [
            _buildBottomItem('barchart'),
            _buildBottomItem('shop'),
            _buildBottomItem('customer'),
            _buildBottomItem('follow'),
            _buildBottomItem('salary'),
          ],
        ),
      ),
    );
  }

  final Map<String, String> imageMap = {
    'barchart': 'assets/images/barchart.png',
    'shop': 'assets/images/shop.png',
    'customer': 'assets/images/customer.png',
    'follow': 'assets/images/follow-up.png',
    'salary': 'assets/images/salary.png',
  };

  Widget _buildCard(String title, String iconKey, [String? subtitle]) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: 155,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imageMap[iconKey] ?? 'assets/images/default.png',
              width: 35,
              height: 35,
              color: Colors.black,
              colorBlendMode: BlendMode.srcIn,
            ),
            SizedBox(height: 8),
            Text(title,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                color: Color(0xFF333333),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            if (subtitle != null) ...[
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 11,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomItem(String key) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        imageMap[key] ?? 'assets/images/default.png',
        width: 30,
        height: 30,
        color: Colors.black,
      ),
      label: '',
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 170,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFFFF6600),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          child: Image(
                            image: AssetImage('assets/images/user.jpg'),
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '{Nombre de Usuario}',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Text(
                              '{Rol de Usuario}',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.manage_accounts),
            title: Text('Ajustes de Perfil'),
            onTap: () {}, // Acción
          ),
          ListTile(
            leading: Icon(Icons.cloud_done),
            title: Text('Sincronización de Datos'),
            onTap: () {}, // Acción
          ),
          ListTile(
            leading: Icon(Icons.airplanemode_inactive),
            title: Text('Modo sin Conexión'),
            onTap: () {}, // Acción
          ),
          ListTile(
            leading: Icon(Icons.notifications_active),
            title: Text('Notificaciones'),
            onTap: () {}, // Acción
          ),
          ListTile(
            leading: Icon(Icons.headset_mic),
            title: Text('Ayuda y Soporte'),
            onTap: () {}, // Acción
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Cerrar Sesión'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            }, // Acción
          ),
        ],
      ),
    );
  }
}
