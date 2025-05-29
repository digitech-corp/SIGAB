import 'package:balanced_foods/models/customer.dart';
import 'package:balanced_foods/models/order.dart';
import 'package:balanced_foods/providers/companies_provider.dart';
import 'package:balanced_foods/providers/customers_provider.dart';
import 'package:balanced_foods/providers/orders_provider.dart';
import 'package:balanced_foods/screens/modulo_pedidos/new_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:balanced_foods/screens/sales_module_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async{
      final customersProvider = Provider.of<CustomersProvider>(context, listen: false);
      final companiesProvider = Provider.of<CompaniesProvider>(context, listen: false);
      final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);

      await customersProvider.fetchCustomers();
      await companiesProvider.fetchCompanies();
      await ordersProvider.fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final orders = ordersProvider.orders;
    final customersProvider = Provider.of<CustomersProvider>(context);
    final companiesProvider = Provider.of<CompaniesProvider>(context);
    final customers = customersProvider.customers;
    final isLoading = ordersProvider.isLoading ||
                  customersProvider.isLoading ||
                  companiesProvider.isLoading;
    final today = DateTime.now();
    final filteredOrders = orders.where((order) {
      final delivery = order.dateCreated;
      return delivery != null &&
            delivery.year == today.year &&
            delivery.month == today.month &&
            delivery.day == today.day;
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
                  'MODULO DE PEDIDOS',
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
                    Text(
                      'Resumen del día',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(today),
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Color(0xFFBDBDBD), thickness: 1.0),
                const SizedBox(height: 10),

                // Resumen de pedidos
                _buildOrderSummary(filteredOrders),
                const SizedBox(height: 20),

                // Título detalles
                const Text(
                  'Detalles de Pedidos',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                const Divider(color: Color(0xFFBDBDBD), thickness: 1.0),
                const SizedBox(height: 10),
              ],
            ),
          ),

          Expanded(
            child: isLoading 
                ? const Center(child: CircularProgressIndicator())
                : filteredOrders.isEmpty
                    ? const Center(child: Text('No hay pedidos disponibles'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) {
                          final order = filteredOrders[index];
                          
                          final firstDetail = order.details.isNotEmpty ? order.details.first : null;
                          Customer? customer;
                          if (firstDetail != null) {
                            try {
                              customer = customers.firstWhere((c) => c.idCustomer == firstDetail.idCustomer);
                            } catch (_) {
                              customer = null;
                            }
                          }

                          String persona = '--';
                          String empresa = '--';

                          if (customer != null) {
                            persona = customer.customerName;
                            empresa = companiesProvider.getCompanyNameById(customer.idCompany);
                          }
                          
                          final codPedido = 'PEDIDO N° ${order.idOrder.toString().padLeft(2, '0')}-2025';
                          final hora = order.timeCreated != null
                              ? '${order.timeCreated!.hour.toString().padLeft(2, '0')}:${order.timeCreated!.minute.toString().padLeft(2, '0')}'
                              : '--:--';
                          final total = order.total;

                          return Row(
                            children: [
                              Expanded(
                                child: _detailOrder(
                                  empresa,
                                  persona,
                                  codPedido,
                                  hora,
                                  total,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
          ),

          // Botón flotante
          Padding(
            padding: const EdgeInsets.only(bottom: 12, right: 16),
            child: Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: const Icon(
                  Icons.add_circle,
                  color: Color(0xFFFF6600),
                  size: 45,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewOrderScreen()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),


    );
  }

  Widget _buildOrderSummary(List<Order> filteredOrders) {
    final totalPedidos = filteredOrders.length;
    final montoTotal = filteredOrders.fold<double>(0, (sum, order) => sum + order.total);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total de Pedidos del día:',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              Text(
                '$totalPedidos',
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Monto facturado:',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              Text(
                'S/. ${montoTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  

  Widget _detailOrder(String company, String person, String codOrder, String hour, double total) {
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
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(
                        'https://img.freepik.com/foto-gratis/joven-barbudo-camisa-rayas_273609-5677.jpg',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          company,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            color: Color(0xFFFF6600),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          person,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 10,
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          codOrder,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 10,
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          hour,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          'S/. ${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}