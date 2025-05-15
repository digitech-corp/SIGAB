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

  final List<Widget> _screens = [
    const DashboardScreen(),
    const CustomerScreen(),
    const OrderScreen(),
    const FollowScreen(),
    const CollectionScreen(),
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
        AppAssets.imageMap[key] ?? 'assets/images/default.png',
        width: 30,
        height: 30,
        color: isSelected ? AppColors.orange : Colors.black,
      ),
      label: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _showMainPanel ? AppColors.orange : Colors.white,
      drawer: _buildDrawer(context),
      body: _showMainPanel ? _buildMainPanel() : _screens[_selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          backgroundColor: Color(0xFFD9D9D9),
          selectedItemColor: AppColors.orange,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final bodyPadding = screenWidth * 0.06;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: bodyPadding),
      child: Column(
        children: [
          const SizedBox(height: 35),
          const SalesModuleHeader(),
          const SizedBox(height: 35),
          SalesModuleCards(onCardTap: _onItemTapped),
        ],
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
                decoration: const BoxDecoration(color: AppColors.orange),
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
                      children: [
                        Text('{Nombre de Usuario}', style: AppTextStyles.titleDrawer),
                        Text('{Rol de Usuario}', style: AppTextStyles.weak),
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
                option: key[0].toUpperCase() + key.substring(1),
                onTap: () {},
              )),
          const Divider(color: AppColors.orange, thickness: 1.09, indent: 20, endIndent: 20),
          buildDrawerTile(
            imageKey: 'logout',
            option: 'Cerrar Sesión',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text('SIGAB - Desarrollado por DIGITECH CORP EIRL', style: AppTextStyles.small),
          ),
        ],
      ),
    );
  }

  Widget buildDrawerTile({
    required String imageKey,
    required String option,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Image.asset(
        AppAssets.imageMap[imageKey] ?? 'assets/images/default.png',
        width: 20,
        height: 20,
        color: Colors.black,
      ),
      title: Text(option, style: AppTextStyles.option),
      onTap: onTap,
    );
  }
}

class SalesModuleHeader extends StatelessWidget {
  const SalesModuleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
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
            Text('Hola {name}', style: AppTextStyles.strong),
            Text('Bienvenida a tu panel de trabajo', style: AppTextStyles.weak),
          ],
        ),
      ],
    );
  }
}

class SalesModuleCards extends StatelessWidget {
  final void Function(int) onCardTap;

  const SalesModuleCards({super.key, required this.onCardTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildCard('Dashboard', 'barchart', null, () => onCardTap(0))),
            const SizedBox(width: 3),
            Expanded(child: _buildCard('Clientes', 'customer', '35 Registros', () => onCardTap(1))),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildCard('Pedidos', 'shop', '5 Registros', () => onCardTap(2))),
            const SizedBox(width: 3),
            Expanded(child: _buildCard('Seguimiento', 'follow', '3 Registros', () => onCardTap(3))),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildCard('Cobranzas', 'salary', '4 Pendientes', () => onCardTap(4))),
            const Spacer(),
          ],
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
                AppAssets.imageMap[iconKey] ?? 'assets/images/default.png',
                width: 35,
                height: 35,
                color: Colors.black,
              ),
              const SizedBox(height: 8),
              Text(title, style: AppTextStyles.titleCard),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyles.small),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AppAssets {
  static const Map<String, String> imageMap = {
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
}

class AppTextStyles {
  static const base = TextStyle(
    fontFamily: 'Montserrat',
      color: AppColors.gris,
      fontWeight: FontWeight.w300,
      fontSize: 14,
  );
  static final strong = base.copyWith(fontWeight: FontWeight.w600,fontSize: 20,decoration: TextDecoration.none);
  static final weak = base.copyWith(decoration: TextDecoration.none);
  static final titleCard = base.copyWith(fontWeight: FontWeight.w500);
  static final small = base.copyWith(fontSize: 11);
  static final titleDrawer = base.copyWith(fontWeight: FontWeight.w600,fontSize: 16);
  static final option = base.copyWith();
}

class AppColors {
  static const orange = Color(0xFFFF6600);
  static const gris = Color(0xFF333333);
}