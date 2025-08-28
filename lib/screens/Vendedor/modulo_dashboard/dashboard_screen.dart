import 'package:balanced_foods/models/order.dart';
import 'package:balanced_foods/providers/dashboard_provider.dart';
import 'package:balanced_foods/providers/entregas_provider.dart';
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
  String _selectedTipo = 'Diario';
  late DateTime fechaInicio;
  late DateTime fechaFin;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final userProvider = Provider.of<UsersProvider>(context, listen: false);
      final token = userProvider.token;
      final idPersonal = userProvider.loggedUser?.idUsuario ?? null;
      final ordersProvider = Provider.of<DashboardProvider>(context, listen: false);
      final entregasProvider = Provider.of<EntregasProvider>(context, listen: false);
      final now = DateTime.now();
      final fechaInicio = DateTime(now.year, now.month, 1);
      final fechaFin = DateTime(now.year, now.month + 1, 0);
      final formato = (DateTime date) => "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      await ordersProvider.fetchOrders(
        token!,
        formato(fechaFin),
        formato(fechaInicio),
        idPersonal,
      );
      for (final order in ordersProvider.orders) {
        if (order.idOrder != null) {
          await entregasProvider.fetchEstadoEntrega(token, order.idOrder!);
        }
      }
      final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
      await productsProvider.fetchProducts(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UsersProvider>(context);
    final loggedUser = provider.loggedUser;
    final ordersProvider = Provider.of<DashboardProvider>(context);
    final entregasProvider = Provider.of<EntregasProvider>(context);
    final orders = ordersProvider.orders.where(
      (order) => (order.state == 1)
    ).toList();

    final now = DateTime.now();
    DateTime inicioFiltro;
    DateTime finFiltro;

    switch (_selectedTipo) {
      case 'Diario':
        inicioFiltro = DateTime(now.year, now.month, now.day);
        finFiltro = inicioFiltro;
        break;

      case 'Semanal':
        final currentWeekday = now.weekday;
        inicioFiltro = DateTime(now.year, now.month, now.day)
            .subtract(Duration(days: currentWeekday - 1));
        finFiltro = inicioFiltro.add(const Duration(days: 6));
        break;

      case 'Mensual':
      default:
        inicioFiltro = DateTime(now.year, now.month, 1);
        finFiltro = DateTime(now.year, now.month + 1, 0);
        break;
    }

    final filteredOrders = orders.where((order) {
      final fechaPedido = order.fechaEmision ?? now;

      return !fechaPedido.isBefore(inicioFiltro) && !fechaPedido.isAfter(finFiltro);
    }).toList();

    final ordersContado = filteredOrders.where((order){
      return order.idPaymentMethod == 195 || order.idPaymentMethod == 16;
    }).toList();
    
    final ordersCredito = filteredOrders.where((order){
      return order.idPaymentMethod == 17;
    }).toList();

    final double totalPorCobrar = ordersCredito.fold(0.0, (suma, order) {
      final total = order.total ?? 0.0;
      final totalPagado = order.totalPagado ?? 0.0;
      return suma + (total - totalPagado);
    });

    final pendientes = filteredOrders.where((order) {
      final estado = entregasProvider.getEstadoPorOrder(order.idOrder!);
      return estado == 'PLANIFICADO' || estado == 'DESPACHO';
    }).toList();

    final totalPendientes = pendientes.length;

    final double montoContado = ordersContado.fold(0.0, (sum, order) => sum + order.total!);
    final double montoCredito = ordersCredito.fold(0.0, (sum, order) => sum + order.total!);

    final cuotaMensual = (loggedUser!.cuotaMensual)!.toDouble();
    final cuotaActual = montoCredito + montoContado;
    final porcentajeUsado = (cuotaActual / cuotaMensual) * 100;
    
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
              VentasTotalesCard(
                selectedTipo: _selectedTipo,
                onTipoChanged: (tipo) async {
                  setState(() {
                    _selectedTipo = tipo;
                  });
                }
              ),
              const SizedBox(height: 20),
              BarraDivididaConTooltip(contado: ordersContado, credito: ordersCredito, montoContado: montoContado, montoCredito: montoCredito),
              const SizedBox(height: 20),
              Text('Cuota de Ventas y Progreso', style: AppTextStyles.subtitle),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: _cuotaCuentaCard('Cuota Mensual', 'S/$cuotaMensual')),
                  const SizedBox(width: 8),
                  Expanded(child: _progresoCard('Progreso Actual', porcentajeUsado, 'S/$cuotaActual')),
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

  static Widget _progresoCard(String title, double percent, String amount) {
    final porcentajeUsadoTexto = '${percent.toStringAsFixed(0)}%';
    Color getPorcentajeColor(double porcentaje) {
      if (porcentaje < 65) {
        return const Color.fromARGB(239, 201, 152, 7);
      } else if (porcentaje <= 100) {
        return AppColors.green;
      } else {
        return AppColors.red;
      }
    }
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
              Text(
                porcentajeUsadoTexto,
                style: AppTextStyles.percent.copyWith(
                  color: getPorcentajeColor(percent),
                ),
              ),
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
  final String selectedTipo;
  final ValueChanged<String> onTipoChanged;

  const VentasTotalesCard({
    super.key,
    required this.selectedTipo,
    required this.onTipoChanged,
  });

  @override
  State<VentasTotalesCard> createState() => _VentasTotalesCardState();
}

class _VentasTotalesCardState extends State<VentasTotalesCard> {
  int _selectedIndex = 0;
  final List<String> _titulos = ['Diario', 'Semanal', 'Mensual'];

  @override
  void initState() {
    super.initState();
    _selectedIndex = _titulos.indexOf(widget.selectedTipo);
    if (_selectedIndex == -1) _selectedIndex = 0;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onTipoChanged(_titulos[index]);
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_titulos.length, (index) {
                final bool isSelected = _selectedIndex == index;
                return GestureDetector(
                  onTap: () => _onItemTapped(index),
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
          Expanded(
            child: Center(
              child: IndexedStack(
                index: _selectedIndex,
                children: const [
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

    final orders = ordersProvider.orders.where(
      (order) => (order.state == 1)
    ).toList();

    final products = productsProvider.products;

    final stillLoading = orders.isEmpty && products.isEmpty;

    if (stillLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (orders.isEmpty || products.isEmpty) {
      return const Center(child: Text("No hubo ventas hoy"));
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

    final orders = ordersProvider.orders.where(
      (order) => (order.state == 1)
    ).toList();

    final products = productsProvider.products;

    final stillLoading = orders.isEmpty && products.isEmpty;

    if (stillLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (orders.isEmpty || products.isEmpty) {
      return const Center(child: Text("No hubo ventas esta semana"));
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

    final orders = ordersProvider.orders.where(
      (order) => (order.state == 1)
    ).toList();
    
    final products = productsProvider.products;

    final stillLoading = orders.isEmpty && products.isEmpty;

    if (stillLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (orders.isEmpty || products.isEmpty) {
      return const Center(child: Text("No hubo ventas este mes"));
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