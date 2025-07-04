import 'package:balanced_foods/models/customer.dart';
import 'package:balanced_foods/models/order.dart';
import 'package:balanced_foods/providers/companies_provider.dart';
import 'package:balanced_foods/providers/customers_provider.dart';
import 'package:balanced_foods/providers/orders_provider.dart';
import 'package:balanced_foods/screens/Reportes/invoice_screen.dart';
import 'package:balanced_foods/screens/sales_module_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CustomersProvider>(context, listen: false).fetchCustomers();
      Provider.of<OrdersProvider>(context, listen: false).fetchOrders();
      Provider.of<CompaniesProvider>(context, listen: false).fetchCompanies();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            backgroundColor: AppColors.orange,
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
                      MaterialPageRoute(
                        builder: (context) => SalesModuleScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 1),
                Text('Módulo de Cobranzas', style: AppTextStyles.title),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(child: Column(children: [const CreditosCard()])),
    );
  }
}

class CreditosCard extends StatefulWidget {
  const CreditosCard({super.key});

  @override
  State<CreditosCard> createState() => _CreditosCardState();
}

class _CreditosCardState extends State<CreditosCard> {
  int _selectedIndex = 0;
  String _sortBy = 'Fecha Vencimiento';
  final List<String> _titulos = ['Créditos Vencidos', 'Créditos por Vencer'];
  final List<String> _sortOptions = [
    'Fecha Vencimiento',
    'Monto Total',
    'Días Vencido',
  ];

  @override
  Widget build(BuildContext context) {
    final customersProvider = Provider.of<CustomersProvider>(context);
    final customers = customersProvider.customers;
    final companiesProvider = Provider.of<CompaniesProvider>(context);
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final orders = ordersProvider.orders;
    final filteredOrders = orders.where((o) => o.paymentState == 'Pendiente').toList();
    final DateTime today = DateTime.now();

    // Filtra los pedidos por estado de vencimiento
    final vencidos = filteredOrders.where(
      (o) => o.deliveryDate != null && o.deliveryDate!.isBefore(today),
    ).toList();

    final porVencer = filteredOrders.where(
      (o) => o.deliveryDate != null && 
            (o.deliveryDate!.isAfter(today) || o.deliveryDate!.isAtSameMomentAs(today)),
    ).toList();

    List<Order> listaAMostrar = _selectedIndex == 0 ? vencidos : porVencer;

  // Ordenar según _sortBy
  listaAMostrar.sort((a, b) {
    switch (_sortBy) {
      case 'Monto Total':
        return b.total.compareTo(a.total); // Descendente
      case 'Días Vencido':
        final int diasA = today.difference(a.deliveryDate ?? today).inDays;
        final int diasB = today.difference(b.deliveryDate ?? today).inDays;
        return diasB.compareTo(diasA); // Más vencido primero
      case 'Fecha Vencimiento':
      default:
        final DateTime fechaA = a.deliveryDate ?? DateTime(2100);
        final DateTime fechaB = b.deliveryDate ?? DateTime(2100);
        return fechaA.compareTo(fechaB); // Ascendente
    }
  });


    return Expanded(
      child: Column(
        children: [
          // Tabs
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_titulos.length, (index) {
              final bool isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected 
                      ? Colors.white
                      : null,
                    border: isSelected
                        ? Border.all(color: AppColors.lightGris)
                        : Border.all(color: AppColors.lightGris),
                  ),
                  child: Text(
                    _titulos[index],
                    style: AppTextStyles.titleCards(isSelected)
                  ),
                ),
              );
            }),
          ),
          const Divider(color: AppColors.lightGris, thickness: 1.0, height: 0,),

          // Ordenar por Dropdown
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Ordenar por: ', style: AppTextStyles.orderby),
                  const SizedBox(width: 5),
                  Container(
                    height: 20,
                    width: 130,
                    child: DropdownButtonFormField<String>(
                      value: _sortBy,
                      style: AppTextStyles.base,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                        border: OutlineInputBorder(),
                      ),
                      items: _sortOptions.map((option) {
                        return DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _sortBy = value);
                        }
                      },
                    ),
                  )
            
                ],
              ),
            ),
          ),
          // Tarjetas scrollables
          Expanded(
          child: ordersProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : listaAMostrar.isEmpty
                  ? const Center(child: Text('No hay créditos pendientes'))
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      itemCount: listaAMostrar.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final order = listaAMostrar[index];

                        final customerId = order.idCustomer;
                        Customer? customer;
                        try {
                          customer = customers.firstWhere((c) => c.idCustomer == customerId);
                        } catch (_) {
                          customer = null;
                        }

                        String persona = customer?.customerName ?? '--';
                        String empresa = companiesProvider.getCompanyNameById(customer?.idCompany ?? 0);
                        final codPedido = 'PEDIDO N° ${order.idOrder.toString().padLeft(2, '0')}-2025';
                        final total = order.total.toStringAsFixed(2);
                        final int diasDiferencia = today.difference(order.deliveryDate!).inDays;

                        final String estadoVencimiento = diasDiferencia > 0 ? 'VENCIDO' : 'POR VENCER';
                        final Color colorTexto = diasDiferencia > 0 ? AppColors.orange : AppColors.blue;

                        return _creditCard(
                          idOrder: order.idOrder ?? 0,
                          cliente: empresa,
                          contacto: persona,
                          pedido: codPedido,
                          estadoVencimiento: estadoVencimiento,
                          vencidoDias: '$diasDiferencia días',
                          monto: 'S/. $total',
                          saldo: 'S/. $total',
                          fechaVencimiento: order.deliveryDate != null
                              ? DateFormat('dd/MM/yy').format(order.deliveryDate!)
                              : 'Sin fecha',
                          colorTexto: colorTexto,
                        );
                      },
                    ),
        )
        ],
      ),
    );
  }

  Widget _creditCard({
    required int idOrder,
    required String cliente,
    required String contacto,
    required String pedido,
    required String estadoVencimiento,
    required String vencidoDias,
    required String monto,
    required String saldo,
    required String fechaVencimiento,
    required Color colorTexto,
  }) {
    //final Color estadoColor = esPorVencer ? Colors.blue : Colors.red;

    final _labelStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 10,
      color: Colors.black,
      fontWeight: FontWeight.w500
    );
    final _weakStyle = _labelStyle.copyWith(fontWeight: FontWeight.w300);
    final _strongStyle = _labelStyle.copyWith(fontWeight: FontWeight.w400); 
    final _customerStyle = _labelStyle.copyWith(fontSize: 12,); 
    final _estadoStyle = _labelStyle.copyWith(color: colorTexto);    
    final _saldoStyle = _labelStyle.copyWith(fontSize: 12, color: colorTexto);    

    return Card(
      color: AppColors.lightGris,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cliente:', style: _strongStyle),
                    const SizedBox(height: 5),
                    Text('Contacto:', style: _strongStyle),
                    const SizedBox(height: 5),
                    Text('N° de Pedido:', style: _strongStyle),
                    const SizedBox(height: 5),
                    Text('Estado Crédito:', style: _strongStyle),
                    const SizedBox(height: 5),
                    Text('N° días Vencido:', style: _strongStyle),
                    const SizedBox(height: 5),
                    Text('Monto Total:', style: _strongStyle),
                    const SizedBox(height: 5),
                    Text('Saldo:', style: _strongStyle),
                  ],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cliente, style: _customerStyle),
                      const SizedBox(height: 5),
                      Text(contacto, style: _weakStyle),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text('PEDIDO N° $pedido', style: _weakStyle),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => InvoiceScreen(
                                  idOrder: idOrder,
                                )),
                              );
                            },
                            child: Icon(
                              Icons.attach_file,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(estadoVencimiento, style: _estadoStyle),
                          Spacer(),
                          Text('Fecha Vencimiento:', style: _strongStyle),
                          const SizedBox(width: 10),
                          Text(fechaVencimiento, style: _weakStyle),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(vencidoDias, style: _estadoStyle),
                              Text(monto, style: _estadoStyle),
                              Text(saldo, style: _saldoStyle),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 25,
                                width: 113,
                                child: OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.orange,
                                    side: BorderSide(color: AppColors.orange, width: 1),
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('Llamar', style: AppTextStyles.icons),
                                      Image.asset(
                                        'assets/images/phone.png',
                                        color: AppColors.orange,
                                        scale: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                height: 25,
                                width: 113,
                                child: OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.orange,
                                    side: BorderSide(color: AppColors.orange, width: 1),
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('Whatsapp', style: AppTextStyles.icons),
                                      Image.asset(
                                        'assets/images/whatsapp.png',
                                        color: AppColors.orange,
                                        scale: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }
}

class AppTextStyles {
  static const base = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w300,
    fontSize: 10,
    color: AppColors.gris
  );
  static final title = base.copyWith(fontSize: 16, fontWeight: FontWeight.w600);
  static final orderby = base.copyWith(fontSize: 12);
  static final icons = base.copyWith(fontWeight: FontWeight.w400, color: AppColors.orange);
  static TextStyle titleCards(bool isSelected) {
    return base.copyWith(
      fontSize: 14, fontWeight: FontWeight.w500, color: isSelected ? AppColors.orange : AppColors.lightGris,
    );
  }
}

class AppColors {
  static const orange = Color(0xFFFF6600);
  static const gris = Color(0xFF333333);
  static const lightGris = Color(0xFFBDBDBD);
  static const blue = Color(0XFF3498DB);
}