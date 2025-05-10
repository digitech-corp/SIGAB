import 'package:balanced_foods/screens/modulo_cobranzas/collection_screen.dart';
import 'package:balanced_foods/screens/modulo_pedidos/order_screen.dart';
import 'package:balanced_foods/screens/modulo_seguimiento/follow_screen.dart';
import 'package:flutter/material.dart';
import 'package:balanced_foods/screens/login_screen.dart';
import 'package:balanced_foods/screens/modulo_dashboard/dashboard_screen.dart';
import 'package:balanced_foods/screens/modulo_clientes/customer_screen.dart';

class SalesModuleScreen extends StatefulWidget {
  const SalesModuleScreen({super.key});

  @override
  State<SalesModuleScreen> createState() => _SalesModuleScreenState();
}

class _SalesModuleScreenState extends State<SalesModuleScreen> {
  bool _showMainPanel = true;
  int _selectedIndex = 0;

  final Map<String, String> imageMap = {
    'barchart': 'assets/images/barchart.png',
    'customer': 'assets/images/customer.png',
    'shop': 'assets/images/shop.png',
    'follow': 'assets/images/follow-up.png',
    'salary': 'assets/images/salary.png',
    'profile': 'assets/images/profile.png',
    'cloud': 'assets/images/cloud.png',
    'offline': 'assets/images/offline.png',
    'notification': 'assets/images/notification.png',
    'help': 'assets/images/help.png',
    'logout': 'assets/images/logout.png',
  };

  final List<Widget> _screens = [
    DashboardScreen(),
    CustomerScreen(),
    OrderScreen(),
    FollowScreen(),
    CollectionScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showMainPanel = false;
    });
  }

  BottomNavigationBarItem _buildBottomItem(String key, int index) {
    final isSelected = !_showMainPanel && _selectedIndex == index;

    return BottomNavigationBarItem(
      icon: Image.asset(
        imageMap[key] ?? 'assets/images/default.png',
        width: 30,
        height: 30,
        color: isSelected ? Color(0xFFFF6600) : Colors.black,
      ),
      label: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _showMainPanel ? const Color(0xFFFF6600) : Colors.white,
      drawer: _buildDrawer(context),
      body: _showMainPanel ? _buildMainPanel() : _screens[_selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          backgroundColor: Color(0xFFD9D9D9),
          selectedItemColor: Color(0xFFFF6600),
          unselectedItemColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          currentIndex: _showMainPanel ? 1 : _selectedIndex,
          onTap: _onItemTapped,
          items: [
            _buildBottomItem('barchart', 0),
            _buildBottomItem('customer', 1),
            _buildBottomItem('shop', 2),
            _buildBottomItem('follow', 3),
            _buildBottomItem('salary', 4),
          ],
        ),
      ),
    );
  }

  Widget _buildMainPanel() {
    return Column(
      children: [
        SizedBox(height: 35),
        // Header con usuario
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(
                    builder: (context) {
                      return IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: const Image(
                            image: AssetImage('assets/images/user.jpg'),
                            width: 35,
                            height: 35,
                            fit: BoxFit.cover,
                          ),
                        ),
                        tooltip: 'Abrir menú',
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hola {name}',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const Text(
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
            ],
          ),
        ),

        const SizedBox(height: 35),
        // Módulos en tarjetas
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildCard('Dashboard', 'barchart', null, () => _onItemTapped(0))),
                  const SizedBox(width: 3),
                  Expanded(child: _buildCard('Clientes', 'customer', '35 Registros', () => _onItemTapped(1))),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _buildCard('Pedidos', 'shop', '5 Registros', () => _onItemTapped(2))),
                  const SizedBox(width: 3),
                  Expanded(child: _buildCard('Seguimiento', 'follow', '3 Registros', () => _onItemTapped(3))),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _buildCard('Cobranzas', 'salary', '4 Pendientes', () => _onItemTapped(4))),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard(String title, String iconKey, [String? subtitle, VoidCallback? onTap]) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 11,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 160,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: DrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFFFF6600)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: const Image(
                        image: AssetImage('assets/images/user.jpg'),
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '{Nombre de Usuario}',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xFF333333),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '{Rol de Usuario}',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xFF333333),
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...[
            'profile',
            'cloud',
            'offline',
            'notification',
            'help',
          ].map((key) => buildDrawerTile(
                imageKey: key,
                title: key[0].toUpperCase() + key.substring(1),
                onTap: () {},
                imageMap: imageMap,
              )),
          const Divider(color: Color(0xFFFF6600), thickness: 1.09, indent: 20, endIndent: 20),
          buildDrawerTile(
            imageKey: 'logout',
            title: 'Cerrar Sesión',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            imageMap: imageMap,
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text(
              'SIGAB - Desarrollado por DIGITECH CORP EIRL',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w300,
                fontFamily: 'Montserrat',
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDrawerTile({
    required String imageKey,
    required String title,
    required VoidCallback onTap,
    required Map<String, String> imageMap,
  }) {
    return ListTile(
      leading: Image.asset(
        imageMap[imageKey] ?? 'assets/images/default.png',
        width: 20,
        height: 20,
        color: Colors.black,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 14,
          color: Color(0xFF333333),
          fontWeight: FontWeight.w300,
        ),
      ),
      onTap: onTap,
    );
  }
}
