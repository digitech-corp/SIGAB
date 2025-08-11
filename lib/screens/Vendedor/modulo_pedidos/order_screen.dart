import 'package:balanced_foods/models/customer.dart';
import 'package:balanced_foods/models/order.dart';
import 'package:balanced_foods/providers/customers_provider.dart';
import 'package:balanced_foods/providers/orders_provider.dart';
import 'package:balanced_foods/providers/users_provider.dart';
import 'package:balanced_foods/screens/Vendedor/modulo_pedidos/new_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:balanced_foods/screens/Vendedor/sales_module_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    Future.microtask(() async{
      final usersProvider = Provider.of<UsersProvider>(context, listen: false);
      final token = usersProvider.token;
      // final idPersonal = usersProvider.loggedUser?.id ?? 0;
      final customersProvider = Provider.of<CustomersProvider>(context, listen: false);
      final ordersProvider = Provider.of<OrdersProvider2>(context, listen: false);

      await customersProvider.fetchCustomers(token!);
      await ordersProvider.fetchOrders(
        token, 
        DateFormat('yyyy-MM-dd').format(selectedDate), 
        DateFormat('yyyy-MM-dd').format(selectedDate), 
        null,
      );
    });
  }

  Future<void> _resetAndFetchOrders() async {
    setState(() {
      selectedDate = DateTime.now();
    });

    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    final token = usersProvider.token;
    final ordersProvider = Provider.of<OrdersProvider2>(context, listen: false);

    await ordersProvider.fetchOrders(
      token!,
      DateFormat('yyyy-MM-dd').format(selectedDate),
      DateFormat('yyyy-MM-dd').format(selectedDate),
      null,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });

      // Llama al provider para actualizar los pedidos según la nueva fecha
      final usersProvider = Provider.of<UsersProvider>(context, listen: false);
      final token = usersProvider.token;
      final ordersProvider = Provider.of<OrdersProvider2>(context, listen: false);

      await ordersProvider.fetchOrders(
        token!,
        DateFormat('yyyy-MM-dd').format(selectedDate),
        DateFormat('yyyy-MM-dd').format(selectedDate),
        null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider2>(context);
    final orders = ordersProvider.orders;
    final customersProvider = Provider.of<CustomersProvider>(context);
    final customers = customersProvider.customers;
    final isLoading = ordersProvider.isLoading ||
                  customersProvider.isLoading;
    final filteredOrders = orders;

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
                Text('MODULO DE PEDIDOS', style: AppTextStyles.title),
              ],
            ),
          ),
        ),
      ),

      body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sección fija superior
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título y fecha
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Resumen del día', style: AppTextStyles.base),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Text(DateFormat('dd/MM/yyyy').format(selectedDate), style: AppTextStyles.date),
                    ),
                  ],
                ),
                const Divider(color: AppColors.lightGris, thickness: 1.0),
                const SizedBox(height: 10),

                // Resumen de pedidos
                _buildOrderSummary(filteredOrders),
                const SizedBox(height: 20),

                // Título detalles
                Text('Detalles de Pedidos', style: AppTextStyles.base),
                const Divider(color: AppColors.lightGris, thickness: 1.0),
                const SizedBox(height: 10),
              ],
            ),
          ),

          Expanded(
            child: Stack(
              children: [
                isLoading 
                    ? const Center(child: CircularProgressIndicator())
                    : filteredOrders.isEmpty
                        ? const Center(child: Text('No hay pedidos disponibles'))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            itemCount: filteredOrders.length,
                            itemBuilder: (context, index) {
                              final order = filteredOrders[index];
                              final firstDetail = order.idCustomer;
                              Customer? customer;
                              try {
                                customer = customers.firstWhere((c) => c.idCliente == firstDetail);
                              } catch (_) {
                                customer = null;
                              }

                              String persona = '--';
                              String empresa = '--';
                              String imagen = '--';

                              if (customer != null) {
                                persona = customer.nombres;
                                imagen = customer.fotoPerfil;                            
                                if (customer.razonSocialAfiliada.trim().isEmpty) {
                                    empresa = customer.razonSocialAfiliada;
                                } else {
                                    empresa = "Sin empresa";
                                }
                              }
                              
                              final codPedido = 'PEDIDO N° ${order.idOrder.toString().padLeft(2, '0')}-2025';
                              final hora = order.horaRegistro != null
                                  ? '${order.horaRegistro!.hour.toString().padLeft(2, '0')}:${order.horaRegistro!.minute.toString().padLeft(2, '0')}'
                                  : '--:--';
                              final total = order.total!;

                              return Row(
                                children: [
                                  Expanded(
                                    child: _detailOrder(
                                      empresa,
                                      persona,
                                      imagen,
                                      codPedido,
                                      hora,
                                      total,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                // Botón flotante
                  Positioned(
                    bottom: 20,
                    right: 15,
                    child: IconButton(
                      icon: const Icon(
                        Icons.add_circle,
                        color: AppColors.orange,
                        size: 45,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewOrderScreen()),
                        ).then((value) {
                          // Aquí hacemos el reset y refrescamos los datos:
                          _resetAndFetchOrders();
                        });
                      },
                      splashColor: Colors.transparent, // Opcional: sin splash visible
                      highlightColor: Colors.transparent, // Opcional: sin highlight
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(List<Order> filteredOrders) {
    final totalPedidos = filteredOrders.length;
    final montoTotal = filteredOrders.fold<double>(0, (sum, order) => sum + order.total!);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total de Pedidos del día:', style: AppTextStyles.subtitle),
              Text('$totalPedidos', style: AppTextStyles.base),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Monto facturado:', style:AppTextStyles.subtitle),
              Text('S/. ${montoTotal.toStringAsFixed(2)}', style: AppTextStyles.base),
            ],
          ),
        ],
      ),
    );
  }
  

  Widget _detailOrder(String company, String person, String imagen, String codOrder, String hour, double total) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        height: 70,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: (imagen.isNotEmpty)
                          ? NetworkImage(imagen)
                          : null,
                      child: (imagen.isEmpty)
                          ? Icon(
                              Icons.person,
                              size: 30,
                              color: AppColors.gris,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(company, style: AppTextStyles.company),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Text(person, style: AppTextStyles.orderinfo, overflow: TextOverflow.ellipsis),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(hour, style: AppTextStyles.hour, textAlign: TextAlign.center),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('S/. ${total.toStringAsFixed(2)}', style: AppTextStyles.total, textAlign: TextAlign.end),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(codOrder, style: AppTextStyles.orderinfo),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}

class AppTextStyles {
  static const base = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: AppColors.gris
  );
  static final title = base.copyWith(fontSize: 16, fontWeight: FontWeight.w600);
  static final date = base.copyWith(fontSize: 12, fontWeight: FontWeight.w300);
  static final subtitle = base.copyWith(fontWeight: FontWeight.w400);
  static final company = base.copyWith(fontSize: 12, color: AppColors.orange);
  static final orderinfo = base.copyWith(fontSize: 10, color: Colors.black, fontWeight: FontWeight.w300);
  static final hour = base.copyWith(fontSize: 10, fontWeight: FontWeight.w300);
  static final total = base.copyWith(fontSize: 12, fontWeight: FontWeight.w400);
}

class AppColors {
  static const orange = Color(0xFFFF6600);
  static const gris = Color(0xFF333333);
  static const backgris = Color(0xFFECEFF1);
  static const lightGris = Color(0xFFBDBDBD);
}