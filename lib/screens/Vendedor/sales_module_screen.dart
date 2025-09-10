import 'package:balanced_foods/providers/customers_provider.dart';
import 'package:balanced_foods/providers/dashboard_provider.dart';
import 'package:balanced_foods/providers/entregas_provider.dart';
import 'package:balanced_foods/providers/orders_provider.dart';
import 'package:balanced_foods/providers/users_provider.dart';
import 'package:balanced_foods/screens/Vendedor/manual_ayuda.dart';
import 'package:balanced_foods/screens/Vendedor/modulo_cobranzas/collection_screen.dart';
import 'package:balanced_foods/screens/Vendedor/modulo_pedidos/order_screen.dart';
import 'package:balanced_foods/screens/Vendedor/modulo_seguimiento/follow_screen.dart';
import 'package:balanced_foods/screens/Vendedor/modulo_usuario/edit_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:balanced_foods/screens/login_screen.dart';
import 'package:balanced_foods/screens/Vendedor/modulo_dashboard/dashboard_screen.dart';
import 'package:balanced_foods/screens/Vendedor/modulo_clientes/customer_screen.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final userProvider = Provider.of<UsersProvider>(context, listen: false);
      final token = userProvider.token;
      final idPersonal = userProvider.loggedUser?.idUsuario ?? null;
      final customersProvider = Provider.of<CustomersProvider>(context, listen: false);
      final dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
      final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
      final entregasProvider = Provider.of<EntregasProvider>(context, listen: false);
      final now = DateTime.now();
      final fechaInicio = DateTime(now.year, now.month, 1);
      final fechaFin = DateTime(now.year, now.month + 1, 0);
      final formato = (DateTime date) => "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      await customersProvider.fetchCustomers(token!);
      await dashboardProvider.fetchOrders(
        token,
        formato(fechaFin),
        formato(fechaInicio),
        idPersonal,
      );
      for (var order in dashboardProvider.orders) {
        await entregasProvider.fetchEstadoEntrega(token, order.idOrder!);
      }
      await ordersProvider.fetchCreditoOrders(
        token,
        formato(fechaInicio),
        formato(fechaFin),
        idPersonal,
      );
    });
  }

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
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.symmetric(horizontal: bodyPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  SalesModuleHeader(),
                  const SizedBox(height: 35),
                  SalesModuleCards(onCardTap: _onItemTapped),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildDrawer(BuildContext context) {
    final provider = Provider.of<UsersProvider>(context);
    final loggedUser = provider.loggedUser;

    if (provider.isLoading) {
      return const Drawer(child: Center(child: CircularProgressIndicator()));
    }
    if (loggedUser == null) {
      return const Drawer(child: Center(child: Text('No se encontró el usuario')));
    }

    return Drawer(
      child: Column(
        children: [
          Container(
            height: 160,
            child: DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.orange),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: (loggedUser.fotoPerfil.isNotEmpty)
                        ? Image.network(
                            'https://adysabackend.facturador.es/archivos/usuarios/${Uri.encodeComponent(loggedUser.fotoPerfil)}',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/user.jpg',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            'assets/images/user.jpg',
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
                      Text(loggedUser.nombres, style: AppTextStyles.titleDrawer),
                      Text(loggedUser.nombreTipoUsuario ?? "", style: AppTextStyles.weak),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...[
            'profile',
            // 'cloud',
            // 'offline',
            'help',
          ].map((key) => buildDrawerTile(
                imageKey: key,
                option: key[0].toUpperCase() + key.substring(1),
                onTap: () {
                  if (key == 'profile') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditUserScreen()),
                    );
                  } else if (key == 'help') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ManualAyudaPage()),
                    );
                  } else {
                    Navigator.pop(context);
                  }
                },
              )),
          const Divider(color: AppColors.orange, thickness: 1.09, indent: 20, endIndent: 20),
          buildDrawerTile(
            imageKey: 'logout',
            option: 'Cerrar Sesión',
            onTap: () {
              Provider.of<UsersProvider>(context, listen: false).logout();
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
    final provider = Provider.of<UsersProvider>(context);
    final loggedUser = provider.loggedUser;

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (loggedUser == null) {
      return const Center(child: Text("No se encontró el usuario"));
    }

    final fotoPerfil = loggedUser.fotoPerfil;
    final usuario = loggedUser.nombres;

    return Row(
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
                    child: fotoPerfil.isNotEmpty
                        ? Image.network(
                            'https://adysabackend.facturador.es/archivos/usuarios/${Uri.encodeComponent(fotoPerfil)}',
                            width: 35,
                            height: 35,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/user.jpg',
                                width: 35,
                                height: 35,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            'assets/images/user.jpg',
                            width: 35,
                            height: 35,
                            fit: BoxFit.cover,
                          ),
                  ),
                  tooltip: 'Abrir menú',
                );
              },
            ),
            const SizedBox(height: 15),
            Text('Hola $usuario', style: AppTextStyles.strong),
            Text('Bienvenido a tu panel de trabajo', style: AppTextStyles.weak),
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
    final customersProvider = Provider.of<CustomersProvider>(context);
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final entregasProvider = Provider.of<EntregasProvider>(context);
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final customersLength = customersProvider.customers.length;
    final ordersLength = dashboardProvider.orders.length;
    final orders = dashboardProvider.orders;
    final creditos = ordersProvider.creditos;

    final filteredEntregas = orders.where((order) {
      String estado = entregasProvider.getEstadoPorOrder(order.idOrder!);
      return estado.isNotEmpty && estado != 'Cargando...';
    }).toList();
    final programados = filteredEntregas.length;
    
    final filteredCreditos = creditos.where((o) => 
      o.total! - o.totalPagado! > 0
    ).toList();
    final cobranzas = filteredCreditos.length;
    
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildCard('Dashboard', 'barchart', null, () => onCardTap(0))),
            const SizedBox(width: 3),
            Expanded(child: _buildCard('Clientes', 'customer', '$customersLength Registros', () => onCardTap(1))),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildCard('Pedidos', 'shop', '$ordersLength Registros', () => onCardTap(2))),
            const SizedBox(width: 3),
            Expanded(child: _buildCard('Seguimiento', 'follow', '$programados Registros', () => onCardTap(3))),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildCard('Cobranzas', 'salary', '$cobranzas Pendientes', () => onCardTap(4))),
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