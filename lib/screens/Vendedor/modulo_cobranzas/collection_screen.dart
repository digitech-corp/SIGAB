import 'package:balanced_foods/models/customer.dart';
import 'package:balanced_foods/models/order.dart';
import 'package:balanced_foods/providers/customers_provider.dart';
import 'package:balanced_foods/providers/facturas_provider.dart';
import 'package:balanced_foods/providers/orders_provider.dart';
import 'package:balanced_foods/providers/users_provider.dart';
import 'package:balanced_foods/screens/Vendedor/sales_module_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  DateTime selectedDateInicio = DateTime.now().subtract(const Duration(days: 30));
  DateTime selectedDateFin = DateTime.now();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final userProvider = Provider.of<UsersProvider>(context, listen: false);
      final token = userProvider.token;
      final idPersonal = userProvider.loggedUser?.idUsuario ?? null;
      final customersProvider = Provider.of<CustomersProvider>(context, listen: false);
      await customersProvider.fetchCustomers(token!);

      final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
      await ordersProvider.fetchCreditoOrders(
        token,
        DateFormat('yyyy-MM-dd').format(selectedDateInicio),
        DateFormat('yyyy-MM-dd').format(selectedDateFin),
        idPersonal,
      );
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
      body: SafeArea(
        child: Column(
          children: [ 
            CreditosCard(
              initialDateInicio: selectedDateInicio,
              initialDateFin: selectedDateFin,
            )
          ]
        )
      ),
    );
  }
}

class CreditosCard extends StatefulWidget {
  final DateTime initialDateInicio;
  final DateTime initialDateFin;
  
  const CreditosCard({
    super.key,
    required this.initialDateInicio,
    required this.initialDateFin,
  });
  @override
  State<CreditosCard> createState() => _CreditosCardState();
}

class _CreditosCardState extends State<CreditosCard> {
  late DateTime selectedDateInicio;
  late DateTime selectedDateFin;

  @override
  void initState() {
    super.initState();
    selectedDateInicio = widget.initialDateInicio;
    selectedDateFin = widget.initialDateFin;
  }

  Future<void> _selectDate({
    required BuildContext context,
    required bool isInicio,
  }) async {
    final initialDate = isInicio ? selectedDateInicio : selectedDateFin;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != initialDate) {
      setState(() {
        if (isInicio) {
          selectedDateInicio = picked;
        } else {
          selectedDateFin = picked;
        }
      });

      final usersProvider = Provider.of<UsersProvider>(context, listen: false);
      final token = usersProvider.token;
      final idPersonal = usersProvider.loggedUser?.idUsuario ?? null;
      final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);

      final fechaInicio = selectedDateInicio.isBefore(selectedDateFin)
          ? selectedDateInicio
          : selectedDateFin;
      final fechaFin = selectedDateInicio.isAfter(selectedDateFin)
          ? selectedDateInicio
          : selectedDateFin;

      await ordersProvider.fetchCreditoOrders(
        token!,
        DateFormat('yyyy-MM-dd').format(fechaInicio),
        DateFormat('yyyy-MM-dd').format(fechaFin),
        idPersonal,
      );
    }
  }

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
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final creditos = ordersProvider.creditos;
    final filteredOrders = creditos.where((o) => 
      o.total! - o.totalPagado! > 0
    ).toList();
    final DateTime today = DateTime.now();

    final vencidos = filteredOrders.where(
      (o) => o.fechaVencimiento != null && o.fechaVencimiento!.isBefore(today),
    ).toList();

    final porVencer = filteredOrders.where(
      (o) => o.fechaVencimiento != null && 
            (o.fechaVencimiento!.isAfter(today) || o.fechaVencimiento!.isAtSameMomentAs(today)),
    ).toList();

    List<Order> listaAMostrar = _selectedIndex == 0 ? vencidos : porVencer;

    listaAMostrar.sort((a, b) {
      switch (_sortBy) {
        case 'Monto Total':
          return b.total!.compareTo(a.total!);
        case 'Días Vencido':
          final int diasA = today.difference(a.fechaVencimiento ?? today).inDays;
          final int diasB = today.difference(b.fechaVencimiento ?? today).inDays;
          return diasB.compareTo(diasA);
        case 'Fecha Vencimiento':
        default:
          final DateTime fechaA = a.fechaVencimiento ?? DateTime(2100);
          final DateTime fechaB = b.fechaVencimiento ?? DateTime(2100);
          return fechaA.compareTo(fechaB);
      }
    });

    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fecha inicio:', style: AppTextStyles.base),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => _selectDate(context: context, isInicio: true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, size: 10, color: Colors.grey.shade700),
                              const SizedBox(width: 8),
                              Text(DateFormat('dd/MM/yyyy').format(selectedDateInicio), style: AppTextStyles.date),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fecha fin:', style: AppTextStyles.base),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => _selectDate(context: context, isInicio: false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, size: 10, color: Colors.grey.shade700),
                              const SizedBox(width: 8),
                              Text(DateFormat('dd/MM/yyyy').format(selectedDateFin), style: AppTextStyles.date),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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

                        final customerId = order.nroDocumento;
                        Customer? customer;
                        try {
                          customer = customers.firstWhere((c) => c.nroDocumento == customerId);
                        } catch (_) {
                          customer = null;
                        }

                        String persona = '${customer?.nombres} ${customer?.apellidos}'.isEmpty
                            ? 'Sin contacto'
                            : '${customer?.nombres} ${customer?.apellidos}';
                        String empresa = '${customer?.razonSocialAfiliada}'.isEmpty
                            ? 'Sin empresa'
                            : '${customer?.razonSocialAfiliada}';

                        final codPedido = 'PEDIDO N° ${order.idOrder.toString().padLeft(2, '0')}-2025';
                        final total = order.total!.toStringAsFixed(2);
                        final totalPagado = order.totalPagado!.toStringAsFixed(2);
                        final int diasDiferencia = today.difference(order.fechaVencimiento!).inDays;

                        final String estadoVencimiento = diasDiferencia > 0 ? 'VENCIDO' : 'POR VENCER';
                        final Color colorTexto = diasDiferencia > 0 ? AppColors.orange : AppColors.blue;

                        return _creditCard(
                          idOrder: order.idOrder ?? 0,
                          cliente: empresa,
                          numero: customer!.numero,
                          contacto: persona,
                          pedido: codPedido,
                          estadoVencimiento: estadoVencimiento,
                          vencidoDias: '$diasDiferencia días',
                          monto: 'S/. $total',
                          saldo: 'S/. $totalPagado',
                          fechaVencimiento: order.fechaVencimiento != null
                              ? DateFormat('dd/MM/yy').format(order.fechaVencimiento!)
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
    required String numero,
    required String contacto,
    required String pedido,
    required String estadoVencimiento,
    required String vencidoDias,
    required String monto,
    required String saldo,
    required String fechaVencimiento,
    required Color colorTexto,
  }) {

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 2, child: Text('Cliente:', style: _strongStyle)),
                    Expanded(flex: 6, child: Text(cliente, style: _customerStyle)),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 2, child: Text('Contacto:', style: _strongStyle)),
                    Expanded(flex: 6, child: Text(contacto, style: _weakStyle)),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 2, child: Text('N° de Pedido:', style: _strongStyle)),
                    Expanded(
                      flex: 6,
                      child: Row(
                        children: [
                          Text(pedido, style: _weakStyle),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              final facturaProvider = Provider.of<FacturasProvider>(context, listen: false);
                              final token = Provider.of<UsersProvider>(context, listen: false).token;
                              facturaProvider.generarTicket(token!, idOrder);
                            },
                            child: Icon(Icons.attach_file, color: Colors.black, size: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 2, child: Text('Estado Crédito:', style: _strongStyle)),
                    Expanded(
                      flex: 6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(estadoVencimiento, style: _estadoStyle),
                          Text('Fecha Vencimiento:', style: _strongStyle),
                          Text(fechaVencimiento, style: _weakStyle),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('N° días Vencido:', style: _strongStyle),
                          const SizedBox(height: 5),
                          Text('Monto Total:', style: _strongStyle),
                          const SizedBox(height: 5),
                          Text('Saldo:', style: _strongStyle),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(vencidoDias, style: _estadoStyle),
                          const SizedBox(height: 5),
                          Text(monto, style: _estadoStyle),
                          const SizedBox(height: 5),
                          Text(saldo, style: _saldoStyle),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 25,
                            width: 113,
                            child: OutlinedButton(
                              onPressed: () async {
                                if (numero.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('No hay número registrado')),
                                  );
                                  return;
                                }
                                final Uri callUri = Uri(scheme: 'tel', path: '+51${numero}');
                                if (await canLaunchUrl(callUri)) {
                                  await launchUrl(callUri);
                                } else {
                                  debugPrint('No se pudo lanzar $callUri');
                                }
                              },
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
                              onPressed: () async {
                                if (numero.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('No hay número registrado')),
                                  );
                                  return;
                                }
                                final Uri whatsappUri = Uri.parse("https://wa.me/+51${numero}");
                                if (await canLaunchUrl(whatsappUri)) {
                                  await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
                                } else {
                                  debugPrint('No se pudo abrir WhatsApp para +51${numero}');
                                }
                              },
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
                    ),
                  ],
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
  static final date = base.copyWith(fontSize: 10, fontWeight: FontWeight.w300);
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