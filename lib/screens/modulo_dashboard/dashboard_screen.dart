import 'package:balanced_foods/models/order.dart';
import 'package:balanced_foods/providers/orders_provider.dart';
import 'package:balanced_foods/providers/products_provider.dart';
import 'package:balanced_foods/screens/modulo_dashboard/chart_daily.dart';
import 'package:balanced_foods/screens/modulo_dashboard/chart_mounthly.dart';
import 'package:balanced_foods/screens/modulo_dashboard/chart_weakly.dart';
import 'package:balanced_foods/screens/modulo_dashboard/paymentMethodG.raphic.dart';
import 'package:flutter/material.dart';
import 'package:balanced_foods/screens/sales_module_screen.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  
  @override
  void initState() {
    super.initState();
    Future.microtask(() async{
      final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
      await ordersProvider.fetchOrders();
      final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
      await productsProvider.fetchProducts();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrdersProvider>(context).orders;
    
    final ordersContado = orders.where((order){
      return order.paymentMethod == "Contado";
    }).toList();
    final ordersCredito = orders.where((order){
      return order.paymentMethod == "Crédito";
    }).toList();
    final deliveryPendiente = orders.where((order) {
      return order.state == "Pendiente";
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          child: AppBar(
            toolbarHeight: 80,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            title: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SalesModuleScreen()),
                    );
                  },
                ),
                const SizedBox(width: 1),
                const Text(
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
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Panel de Ventas',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),

              const SizedBox(height: 20),
              const VentasTotalesCard(),
              const SizedBox(height: 15),
              BarraDivididaConTooltip(contado: ordersContado.length, credito: ordersCredito.length),
              const SizedBox(height: 20),
              const Text(
                'Cuota de Ventas y Progreso',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),

              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: _cuotaCuentaCard('Cuota Mensual', 'S/20,000.00')),
                  const SizedBox(width: 8),
                  Expanded(child: _progresoCard('Progreso Actual', '75%', 'S/15,000.00')),
                ],
              ),

              const SizedBox(height: 20),
              const Text(
                'Cuentas y Pedidos',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),

              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: _cuotaCuentaCard('Créditos por Cobrar', 'S/5,600.00')),
                  const SizedBox(width: 8),
                  Expanded(child: _pedidoCard('Pedidos por Entregar', '${deliveryPendiente.length}', 'Pedidos pendientes')),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _cuotaCuentaCard(String title, String amount) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        height: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  color: Color(0xFFFF6600),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                amount,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _progresoCard(String title, String percent, String amount) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        height: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  color: Color(0xFFFF6600),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                percent,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  color: Color(0xFF2ECC71),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                amount,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 10,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _pedidoCard(String title, String count, String subtitle) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        height: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  color: Color(0xFFFF6600),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                count,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  color: Color(0xFFE74C3C),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 10,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VentasTotalesCard extends StatefulWidget {
  const VentasTotalesCard({super.key});

  @override
  State<VentasTotalesCard> createState() => _VentasTotalesCardState();
}

class _VentasTotalesCardState extends State<VentasTotalesCard> {
  int _selectedIndex = 0;
  final List<String> _titulos = ['Diario', 'Semanal', 'Mensual'];

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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_titulos.length, (index) {
                final bool isSelected = _selectedIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : const Color(0xFFECEFF1),
                      borderRadius: BorderRadius.circular(10),
                      border: isSelected
                          ? Border.all(color: const Color(0xFFFF6600), width: 2)
                          : null,
                    ),
                    child: Text(
                      _titulos[index],
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: isSelected ? const Color(0xFFFF6600) : const Color(0xFF333333),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          // Contenido del gráfico
          Expanded(
            child: Center(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  DashboardDaily(),
                  DashboardWeekly(),
                  DashboardMonthly(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardDaily extends StatelessWidget {
  const DashboardDaily({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);

    final orders = ordersProvider.orders;
    final products = productsProvider.products;

    final isLoading = orders.isEmpty || products.isEmpty;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    List<Order> filterOrdersByToday(List<Order> orders) {
      final today = DateTime.now();
      return orders.where((order) {
        final created = order.dateCreated;
        if (created == null) return false;
        return created.year == today.year &&
            created.month == today.month &&
            created.day == today.day;
      }).toList();
    }

    final todayOrders = filterOrdersByToday(orders);
    final salesData = buildSalesDataByAnimalType(todayOrders, products);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SalesDonutChart(data: salesData),
    );
  }
}

class DashboardWeekly extends StatelessWidget {
  const DashboardWeekly({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);

    final orders = ordersProvider.orders;
    final products = productsProvider.products;

    final isLoading = orders.isEmpty || products.isEmpty;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    List<Order> filterOrdersByLast7Days(List<Order> orders) {
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 6));

      return orders.where((order) {
        final d = order.dateCreated;
        if (d == null) return false;
        return d.isAfter(sevenDaysAgo.subtract(const Duration(seconds: 1))) &&
              d.isBefore(now.add(const Duration(days: 1)));
      }).toList();
    }

    final weekOrders = filterOrdersByLast7Days(orders);
    final salesData = buildSalesDataByAnimalTypeWeekly(weekOrders, products);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: WeeklyBarChart(data: salesData),
    );
  }
}

class DashboardMonthly extends StatefulWidget {
  const DashboardMonthly({super.key});

  @override
  State<DashboardMonthly> createState() => _DashboardMonthlyState();
}

class _DashboardMonthlyState extends State<DashboardMonthly> {
  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);

    final orders = ordersProvider.orders;
    final products = productsProvider.products;

    final isLoading = orders.isEmpty || products.isEmpty;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Filtrar órdenes desde enero hasta el mes actual
    List<Order> filterOrdersByMonth(List<Order> orders) {
      final now = DateTime.now();
      final startOfYear = DateTime(now.year, 1, 1);

      return orders.where((order) {
        final d = order.dateCreated;
        if (d == null) return false;
        return d.isAfter(startOfYear.subtract(const Duration(seconds: 1))) &&
            d.isBefore(now.add(const Duration(days: 1)));
      }).toList();
    }

    // Aplicar el filtro y generar datos
    final monthOrders = filterOrdersByMonth(orders);

    // buildSalesDataByAnimalTypeMonthly ahora devuelve un Future<Map<String, List<MonthlySalesData>>>
    return FutureBuilder<Map<String, List<MonthlySalesData>>>(
      future: buildSalesDataByAnimalTypeMonthly(monthOrders, products),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay datos'));
        }
        // Mostrar el gráfico con los datos agrupados por animalType
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: MonthlyLineChart(dataByAnimalType: snapshot.data!),
        );
      },
    );
  }
}