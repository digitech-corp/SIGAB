import 'package:balanced_foods/models/customer.dart';
import 'package:balanced_foods/models/entrega.dart';
import 'package:balanced_foods/providers/customers_provider.dart';
import 'package:balanced_foods/providers/entregas_provider.dart';
import 'package:balanced_foods/providers/facturas_provider.dart';
import 'package:balanced_foods/providers/users_provider.dart';
import 'package:balanced_foods/screens/Transportista/transport_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EntregasTerminadasScreen extends StatefulWidget {
  const EntregasTerminadasScreen({super.key});

  @override
  State<EntregasTerminadasScreen> createState() => _EntregasTerminadasScreenState();
}

class _EntregasTerminadasScreenState extends State<EntregasTerminadasScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async{
      final customersProvider = Provider.of<CustomersProvider>(context, listen: false);
      final entregasProvider = Provider.of<EntregasProvider>(context, listen: false);

      final userProvider = Provider.of<UsersProvider>(context, listen: false);
      final idTransportista = userProvider.loggedUser?.idTransportista ?? null;
      final token = userProvider.token;

      await customersProvider.fetchCustomers(token!);
      await entregasProvider.fetchEntregas(token, DateFormat('yyyy-MM-dd').format(selectedDate), DateFormat('yyyy-MM-dd').format(selectedDate), idTransportista);
    });
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

      final usersProvider = Provider.of<UsersProvider>(context, listen: false);
      final idTransportista = usersProvider.loggedUser?.idTransportista ?? null;
      final token = usersProvider.token;
      final entregasProvider = Provider.of<EntregasProvider>(context, listen: false);
      await entregasProvider.fetchEntregas(token!, DateFormat('yyyy-MM-dd').format(selectedDate), DateFormat('yyyy-MM-dd').format(selectedDate), idTransportista);
    }
  }

  @override
  Widget build(BuildContext context) {
    final entregasProvider = Provider.of<EntregasProvider>(context);
    final customersProvider = Provider.of<CustomersProvider>(context);
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    final token = usersProvider.token;
    final entrega = entregasProvider.entregas;
    final isLoading = entregasProvider.isLoading;
    final customers = customersProvider.customers;

    final filteredEntregas = entrega.where((entrega) {
      final fecha = entrega.fechaProgramacion;
      final estadosPermitidos = [239, 240];
      if (fecha == null || token == null) return false;

      return fecha.year == selectedDate.year &&
            fecha.month == selectedDate.month &&
            fecha.day == selectedDate.day &&
            estadosPermitidos.contains(entrega.idEstado);
    }).toList();

    final Map<String, List<Entrega>> entregasPorZona = {};

    for (var e in filteredEntregas) {
      final zona = e.nombreRuta ?? 'Sin zona';
      entregasPorZona.putIfAbsent(zona, () => []).add(e);
    }

    const prioridadOrden = {'Alta': 0, 'Media': 1, 'Baja': 2};

    entregasPorZona.forEach((zona, lista) {
      lista.sort((a, b) {
        final prioridadA = prioridadOrden[a.prioridad ?? 'Media'] ?? 1;
        final prioridadB = prioridadOrden[b.prioridad ?? 'Media'] ?? 1;
        return prioridadA.compareTo(prioridadB);
      });
    });
        
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
                      MaterialPageRoute(builder: (context) => TransportScreen()),
                    );
                  },
                ),
                const SizedBox(width: 1),
                Text('MODULO DE TRANSPORTISTA', style: AppTextStyles.title),
              ],
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Entregas del día', style: AppTextStyles.subtitle),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Text(DateFormat('dd/MM/yyyy').format(selectedDate), style: AppTextStyles.date),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.backgris, thickness: 1.0),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : entregasPorZona.isEmpty
                      ? const Center(child: Text('No hay pedidos disponibles'))
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                          children: entregasPorZona.entries.map((entry) {
                            final zona = entry.key;
                            final entregasZona = entry.value;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Zona: $zona',
                                  style: AppTextStyles.subtitle, // o cualquier estilo que uses
                                ),
                                const SizedBox(height: 6),
                                ...entregasZona.map((entrega) {
                                  final firstDetail = entrega.idCustomer;
                                  Customer? customer;
                                  try {
                                    customer = customers.firstWhere((c) => c.idCliente == firstDetail);
                                  } catch (_) {
                                    customer = null;
                                  }

                                  String persona = '--';
                                  String empresa = '--';
                                  String fullAddress = entrega.direccionEntrega ?? '--';
                                  String customerPhone = '--';
                                  String estado = entrega.estado!;

                                  if (customer != null) {
                                    persona = '${customer.nombres} ${customer.apellidos}';
                                    empresa = customer.razonSocialAfiliada.isNotEmpty
                                        ? customer.razonSocialAfiliada
                                        : "Sin empresa afiliada";
                                    customerPhone = customer.numero;
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: OrderCard(
                                      empresa: empresa,
                                      persona: persona,
                                      estado: estado,
                                      customerPhone: customerPhone,
                                      idOrder: entrega.idOrder,
                                      fullAddress: fullAddress,
                                    ),
                                  );
                                }).toList(),
                                const SizedBox(height: 20),
                              ],
                            );
                          }).toList(),
                        ),
            ),
          ],
        ),
      ),
    );
  } 
}

class OrderCard extends StatefulWidget {
  final empresa;
  final persona;
  final estado;
  final customerPhone;
  final idOrder;
  final fullAddress;
  
  const OrderCard({super.key, required this.empresa, required this.estado, required this.persona, required this.customerPhone, required this.idOrder, required this.fullAddress});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    final codPedido = 'PEDIDO N° ${widget.idOrder.toString().padLeft(2, '0')}-2025';
    final estado = widget.estado;
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.empresa, style: AppTextStyles.company),
                      const SizedBox(height: 2),
                      Text(widget.persona, style: AppTextStyles.orderData),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(codPedido, style: AppTextStyles.orderData),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTextStyles.estadoBackground(estado),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              estado.toUpperCase(),
                              style: AppTextStyles.estadoTextStyle(estado),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  iconSize: 22,
                  icon: const Icon(Icons.attach_file, color: Colors.black),
                  onPressed: () async {
                    final facturaProvider = Provider.of<FacturasProvider>(context, listen: false);
                    final token = Provider.of<UsersProvider>(context, listen: false).token;
                    facturaProvider.generarTicket(token!, widget.idOrder);
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  iconSize: 20,
                  visualDensity: VisualDensity.compact,
                  icon: SizedBox(
                    width: 16,
                    height: 16,
                    child: Image.asset('assets/images/whatsapp.png', color: AppColors.orange),
                  ),
                  onPressed: () async {
                    if (widget.customerPhone.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No hay número registrado')),
                      );
                      return;
                    }
                    final Uri whatsappUri = Uri.parse("https://wa.me/+51${widget.customerPhone}");
                    if (await canLaunchUrl(whatsappUri)) {
                      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
                    } else {
                      debugPrint('No se pudo abrir WhatsApp para +51${widget.customerPhone}');
                    }
                  },
                ),
                IconButton(
                  iconSize: 20,
                  visualDensity: VisualDensity.compact,
                  icon: SizedBox(
                    width: 16,
                    height: 16,
                    child: Image.asset('assets/images/phone.png', color: AppColors.orange),
                  ),
                  onPressed: () async {
                    if (widget.customerPhone.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No hay número registrado')),
                      );
                      return;
                    }
                    final Uri callUri = Uri(scheme: 'tel', path: '+51${widget.customerPhone}');
                    if (await canLaunchUrl(callUri)) {
                      await launchUrl(callUri);
                    } else {
                      debugPrint('No se pudo lanzar $callUri');
                    }
                  },
                ),
                IconButton(
                  icon: SizedBox(
                    width: 18,
                    height: 18,
                    child: Image.asset(
                      'assets/images/gps.png',
                      color: AppColors.orange,
                    ),
                  ),
                  onPressed: () async {
                    final Uri mapsUri = Uri.parse(
                      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(widget.fullAddress)}',
                    );
                    if (await canLaunchUrl(mapsUri)) {
                      await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
                    } else {
                      debugPrint('No se pudo abrir Google Maps');
                    }
                  },
                ),
              ],
            ),
          ],
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
    color: Colors.black
  );
  static final title = base.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.gris);
  static final subtitle = base.copyWith(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.gris);
  static final date = base.copyWith(fontSize: 12, color: AppColors.gris);
  static final company = base.copyWith(fontSize: 12, color: AppColors.orange, fontWeight: FontWeight.w500);
  static final orderData = base.copyWith();
  static final btnDetails = base.copyWith(fontWeight: FontWeight.w400, color: AppColors.orange);
  static final detailsHead = base.copyWith(fontWeight: FontWeight.w400);
  static final btnConfirmar = base.copyWith(fontWeight: FontWeight.w400, color: Colors.white);

  static TextStyle estadoTextStyle(String estado) {
    Color color;
    switch (estado.toLowerCase()) {
      case 'no entregado':
        color = AppColors.red;
        break;
      case 'entregado':
        color = AppColors.green;
        break;
      default:
        color = AppColors.gris;
    }
    return base.copyWith(fontSize: 9, fontWeight: FontWeight.w400, color: color);
  }

  static Color estadoBackground(String estado) {
    switch (estado.toLowerCase()) {
      case 'no entregado':
        return Color(0xFFFEE2E2);
      case 'entregado':
        return Color(0xFFDCFCE7);
      default:
        return Color(0xFFEEEEEE);
    }
  }
}

class AppColors {
  static const orange = Color(0xFFFF6600);
  static const gris = Color(0xFF333333);
  static const backgris = Color(0xFFECEFF1);
  static const lightGris = Color(0xFFBDBDBD);
  static const red = Color(0xFF991B1B);
  static const orangeLight = Color(0xFF854D0E);
  static const green = Color(0xFF166534);
}