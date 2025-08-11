import 'package:balanced_foods/models/order.dart';
import 'package:balanced_foods/providers/dashboard_provider.dart';
import 'package:balanced_foods/providers/entregas_provider.dart';
// import 'package:balanced_foods/providers/orders_provider.dart';
import 'package:balanced_foods/providers/products_provider.dart';
import 'package:balanced_foods/providers/users_provider.dart';
import 'package:balanced_foods/screens/Vendedor/modulo_dashboard/chart_daily.dart';
import 'package:balanced_foods/screens/Vendedor/modulo_dashboard/chart_mounthly.dart';
import 'package:balanced_foods/screens/Vendedor/modulo_dashboard/chart_weakly.dart';
import 'package:balanced_foods/screens/Vendedor/modulo_dashboard/paymentMethodG.raphic.dart';
import 'package:flutter/material.dart';
import 'package:balanced_foods/screens/Vendedor/sales_module_screen.dart';
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
      final ordersProvider = Provider.of<DashboardProvider>(context, listen: false);
      final userProvider = Provider.of<UsersProvider>(context, listen: false);
      final entregasProvider = Provider.of<EntregasProvider>(context, listen: false);
      final token = userProvider.token;
      final now = DateTime.now();
      final fechaInicio = DateTime(now.year, now.month, 1);
      final fechaFin = DateTime(now.year, now.month + 1, 0);
      final formato = (DateTime date) => "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      await ordersProvider.fetchOrders(
        token!,
        formato(fechaFin),
        formato(fechaInicio),
        null,
      );
      for (final order in ordersProvider.orders) {
        if (order.idOrder != null) {
          await entregasProvider.fetchEstadoEntrega(token, order.idOrder!);
        }
      }
      // await entregasProvider.fetchEntregas(token, DateFormat('yyyy-MM-dd').format(now));
      final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
      await productsProvider.fetchProducts(token);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<DashboardProvider>(context);
    final entregasProvider = Provider.of<EntregasProvider>(context);
    // final entrega = entregasProvider.entregas;
    final orders = ordersProvider.orders;
    print('Total de pedidos: ${orders.length}');
    
    final ordersContado = orders.where((order){
      return order.idPaymentMethod == 195 || order.idPaymentMethod == 16;
    }).toList();
    
    final ordersCredito = orders.where((order){
      return order.idPaymentMethod == 17;
    }).toList();

    print('contado: ${ordersContado.length}');
    print('credito: ${ordersCredito.length}');

    final double totalPorCobrar = ordersCredito.fold(0.0, (suma, order) {
      final total = order.total ?? 0.0;
      final totalPagado = order.totalPagado ?? 0.0;
      return suma + (total - totalPagado);
    });

    // borrar si es por metodo de abajo, por programaciones de entrega del dia actual
    final pendientes = orders.where((order) {
      final estado = entregasProvider.getEstadoPorOrder(order.idOrder!);
      return estado == '237' || estado == '238';
    }).toList();

    final totalPendientes = pendientes.length;

    // final entregasPendientes = entrega.where((entrega) {
    //   final estadosPermitidos = [237, 238];

    //   return estadosPermitidos.contains(entrega.idEstado);
    // }).toList();

    final double montoContado = ordersContado.fold(0.0, (sum, order) => sum + order.total!);
    final double montoCredito = ordersCredito.fold(0.0, (sum, order) => sum + order.total!);

    return Scaffold(
      backgroundColor: AppColors.backgris,
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
                Text('Dashboard', style: AppTextStyles.title),
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
              Text('Panel de Ventas', style: AppTextStyles.subtitle),
              const SizedBox(height: 20),
              const VentasTotalesCard(),
              const SizedBox(height: 20),
              BarraDivididaConTooltip(contado: ordersContado.length, credito: ordersCredito.length, montoContado: montoContado, montoCredito: montoCredito),
              const SizedBox(height: 20),
              Text('Cuota de Ventas y Progreso', style: AppTextStyles.subtitle),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: _cuotaCuentaCard('Cuota Mensual', 'S/20,000.00')),
                  const SizedBox(width: 8),
                  Expanded(child: _progresoCard('Progreso Actual', '75%', 'S/15,000.00')),
                ],
              ),

              const SizedBox(height: 20),
              Text('Cuentas y Pedidos', style: AppTextStyles.subtitle),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: _cuotaCuentaCard('Créditos por Cobrar', 'S/ $totalPorCobrar')),
                  const SizedBox(width: 8),
                  Expanded(child: _pedidoCard('Pedidos por Entregar', '$totalPendientes', 'Entregas pendientes hoy')),
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
              Text(title, style: AppTextStyles.titlecard),
              const SizedBox(height: 8),
              Text(amount, style: AppTextStyles.infocard),
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
              Text(title, style: AppTextStyles.titlecard),
              const SizedBox(height: 8),
              Text(percent, style: AppTextStyles.percent),
              const SizedBox(height: 8),
              Text(amount, style: AppTextStyles.infocard),
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
              Text(title, style: AppTextStyles.titlecard),
              const SizedBox(height: 8),
              Text(count, style: AppTextStyles.count),
              const SizedBox(height: 8),
              Text(subtitle, style: AppTextStyles.infocard),
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
                      color: isSelected ? Colors.white : AppColors.backgris,
                      borderRadius: BorderRadius.circular(10),
                      border: isSelected
                          ? Border.all(color: AppColors.orange, width: 2)
                          : null,
                    ),
                    child: Text(
                      _titulos[index],
                      style: AppTextStyles.titleCards(isSelected)
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
    final ordersProvider = Provider.of<DashboardProvider>(context);
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
        final created = order.fechaEmision;
        if (created == null) return false;
        return created.year == today.year &&
            created.month == today.month &&
            created.day == today.day;
      }).toList();
    }

    final todayOrders = filterOrdersByToday(orders);
    final salesData = buildSalesDataByAnimalType(todayOrders, products);
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SalesDonutChart(data: salesData),
    );
  }
}

class DashboardWeekly extends StatelessWidget {
  const DashboardWeekly({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<DashboardProvider>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);

    final orders = ordersProvider.orders;
    final products = productsProvider.products;

    final isLoading = orders.isEmpty || products.isEmpty;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    List<Order> filterOrdersByCurrentWeek(List<Order> orders) {
      final now = DateTime.now();

      final currentWeekday = now.weekday;

      final startOfWeek = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: currentWeekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));

      return orders.where((order) {
        final d = order.fechaEmision;
        if (d == null) return false;

        return !d.isBefore(startOfWeek) && !d.isAfter(endOfWeek);
      }).toList();
    }

    final weekOrders = filterOrdersByCurrentWeek(orders);
    final salesData = buildSalesDataByAnimalTypeWeekly(weekOrders, products);

    return Padding(
      padding: const EdgeInsets.all(8.0),
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
    final ordersProvider = Provider.of<DashboardProvider>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);

    final orders = ordersProvider.orders;
    final products = productsProvider.products;

    final isLoading = orders.isEmpty || products.isEmpty;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    List<Order> filterOrdersByMonth(List<Order> orders) {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final startOfNextMonth = DateTime(now.year, now.month + 1, 1);

      return orders.where((order) {
        final d = order.fechaEmision;
        if (d == null) return false;
        return d.isAtSameMomentAs(startOfMonth) || 
              (d.isAfter(startOfMonth) && d.isBefore(startOfNextMonth));
      }).toList();
    }

    final monthOrders = filterOrdersByMonth(orders);

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
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: MonthlyLineChart(dataByAnimalType: snapshot.data!),
        );
      },
    );
  }
}

class AppTextStyles {
  static const base = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: AppColors.gris
  );
  static final title = base.copyWith(fontSize: 16, fontWeight: FontWeight.w600);
  static final subtitle = base.copyWith(fontSize: 14, fontWeight: FontWeight.w500);
  static final titlecard = base.copyWith(color: AppColors.orange);
  static final infocard = base.copyWith(fontSize: 10, color: Colors.black);
  static final percent = base.copyWith(fontSize: 20, color: AppColors.green);
  static final count = base.copyWith(fontSize: 20, color: AppColors.red);
  static TextStyle titleCards(bool isSelected) {
    return base.copyWith(
      color: isSelected ? AppColors.orange : AppColors.gris,
    );
  }
}

class AppColors {
  static const orange = Color(0xFFFF6600);
  static const gris = Color(0xFF333333);
  static const backgris = Color(0xFFECEFF1);
  static const green = Color(0xFF2ECC71);
  static const red = Color(0xFFE74C3C);
}