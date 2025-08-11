import 'package:balanced_foods/models/customer.dart';
import 'package:balanced_foods/models/order.dart';
import 'package:balanced_foods/models/orderDetail.dart';
import 'package:balanced_foods/models/product.dart';
import 'package:balanced_foods/providers/customers_provider.dart';
import 'package:balanced_foods/providers/entregas_provider.dart';
import 'package:balanced_foods/providers/follow_provider.dart';
import 'package:balanced_foods/providers/products_provider.dart';
import 'package:balanced_foods/providers/ubigeos_provider.dart';
import 'package:balanced_foods/providers/users_provider.dart';
import 'package:balanced_foods/screens/Vendedor/modulo_pedidos/part_order.dart';
import 'package:balanced_foods/screens/Vendedor/modulo_pedidos/product_catalog_screen.dart';
import 'package:balanced_foods/screens/Vendedor/sales_module_screen.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:latlong2/latlong.dart' as latlng;

class FollowScreen extends StatefulWidget {
  const FollowScreen({super.key});

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  DateTime selectedDate = DateTime.now();
  
  @override
  void initState() {
    super.initState();
      Future.microtask(() async {
        final customersProvider = Provider.of<CustomersProvider>(context, listen: false);
        final usersProvider = Provider.of<UsersProvider>(context, listen: false);
        final ubigeosProvider = Provider.of<UbigeosProvider>(context, listen: false);
        final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
        final ordersProvider = Provider.of<FollowProvider>(context, listen: false);
        final token = usersProvider.token;
        customersProvider.fetchCustomers(token!);
        productsProvider.fetchProducts(token);
        ubigeosProvider.fetchUbigeos(token);
        ordersProvider.fetchOrders(token, DateFormat('yyyy-MM-dd').format(selectedDate), DateFormat('yyyy-MM-dd').format(selectedDate), null);
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
      final token = usersProvider.token;
      final ordersProvider = Provider.of<FollowProvider>(context, listen: false);

      await ordersProvider.fetchOrders(
        token!,
        DateFormat('yyyy-MM-dd').format(selectedDate),
        DateFormat('yyyy-MM-dd').format(selectedDate),
        null
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<EntregasProvider>(
      builder: (context, entregasProvider, child) {
        return Consumer<FollowProvider>(
          builder: (context, ordersProvider, child) {
            final screenWidth = MediaQuery.of(context).size.width;
            final bodyPadding = screenWidth * 0.06;
            final orders = ordersProvider.orders;

            final estadoCargando = 'Cargando...';

            final usersProvider = Provider.of<UsersProvider>(context, listen: false);
            final token = usersProvider.token;

            final filteredOrders = orders.where((order) {
              final deliveryDate = order.fechaEmision;
              if (deliveryDate == null || token == null) return false;

              if (deliveryDate.year != selectedDate.year ||
                  deliveryDate.month != selectedDate.month ||
                  deliveryDate.day != selectedDate.day) {
                return false;
              }

              String estado = entregasProvider.getEstadoPorOrder(order.idOrder!);
              if (estado == estadoCargando) {
              Future.microtask(() => entregasProvider.fetchEstadoEntrega(token, order.idOrder!));
              }

              return estado.isNotEmpty && estado != estadoCargando; 
            }).toList();

            return Scaffold(
              backgroundColor: AppColors.lightGrey,
              appBar: const FollowScreenHeader(),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: bodyPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleAndDate(),
                      const Divider(color: AppColors.grey, thickness: 1.0),
                      const SizedBox(height: 10),
                      const FollowOrderHeaderRow(),
                      const Divider(color: AppColors.grey, thickness: 1.0),
                      const SizedBox(height: 10),
                      Builder(
                        builder: (context) {
                          if (ordersProvider.isLoading || entregasProvider.isLoading) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          if (filteredOrders.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Center(
                                child: Text(
                                  'No hay entrega de pedidos programados',
                                  style: AppTextStyles.itemTable,
                                ),
                              ),
                            );
                          }

                          // Lista de entregas
                          return Column(
                            children: filteredOrders.asMap().entries.map((entry) {
                              final index = entry.key;
                              final order = entry.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: OrderCard(order: order, index: index),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        );
      }
    );
  }

  Widget _buildTitleAndDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Pedidos del día', style: AppTextStyles.subtitle),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Text(
            DateFormat('dd/MM/yyyy').format(selectedDate),
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: Color(0xFF333333),
            ),
          ),
        ),
      ],
    );
  }
}

class FollowScreenHeader extends StatelessWidget implements PreferredSizeWidget {
  const FollowScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SalesModuleScreen()),
                );
              },
            ),
            const SizedBox(width: 1),
            Text('Modulo de Seguimiento de Pedidos', style: AppTextStyles.title),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class FollowOrderHeaderRow extends StatelessWidget {
  const FollowOrderHeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Item', style: AppTextStyles.itemTable),
        Text('N° Pedido', style: AppTextStyles.itemTable),
        Text('Estado', style: AppTextStyles.itemTable),
        Text('F. entrega', style: AppTextStyles.itemTable),
        Text('Lugar', style: AppTextStyles.itemTable),
        Text('Detalle', style: AppTextStyles.itemTable),
      ],
    );
  }
}

class OrderCard extends StatefulWidget {
  final Order order;
  final int index;

  const OrderCard({super.key, required this.order, required this.index});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _isExpanded = false;

  String capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}' : '';

  String formatUbigeo(String dist) {
    return '${capitalize(dist)}';
  }

  @override
  Widget build(BuildContext context) {
    final entregasProvider = Provider.of<EntregasProvider>(context);
    final estado = entregasProvider.getEstadoPorOrder(widget.order.idOrder!);

    if (estado == 'Cargando...') {
      final usersProvider = Provider.of<UsersProvider>(context, listen: false);
      final token = usersProvider.token;
      if (token != null) {
        Future.microtask(() => entregasProvider.fetchEstadoEntrega(token, widget.order.idOrder!));
      }
    }
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          SizedBox(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 0.5),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${(widget.index + 1).toString().padLeft(2, '0')}',
                    style: AppTextStyles.weak,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'P-${widget.order.idOrder.toString().padLeft(2, '0')}-2025',
                    style: AppTextStyles.weak,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    estado,
                    style: AppTextStyles.estadoTextStyle(estado)
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '${widget.order.deliveryDate != null ? DateFormat('dd/MM/yy').format(widget.order.deliveryDate!) : "-"}',
                    style: AppTextStyles.weak,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    (widget.order.deliveryLocation?.trim().isEmpty ?? true)
                        ? "Sin dirección"
                        : widget.order.deliveryLocation!,
                    style: AppTextStyles.weak,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: 20,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Image.asset(
                        _isExpanded
                            ? 'assets/images/eyeOpen.png'
                            : 'assets/images/eyeClose.png',
                        width: 15,
                        height: 15,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() => _isExpanded = !_isExpanded);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isExpanded)
            OrderExpandedDetail(order: widget.order),
        ],
      ),
    );
  }
}

class OrderExpandedDetail extends StatelessWidget {
  // final Entrega entrega;
  final Order order;
  const OrderExpandedDetail({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final customersProvider = Provider.of<CustomersProvider>(context, listen: false);
    // final ubigeosProvider = Provider.of<UbigeosProvider>(context, listen: false);
    final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    final screenWidth = MediaQuery.of(context).size.width;
  //   final customer = customersProvider.customers.firstWhere(
  //   (c) => c.idCliente == order.idCustomer,
  //   orElse: () => Customer(
  //     idCliente: 0,
  //     idListaPrecio: 0,
  //     estado: 0,
  //     fechaCreado: '',
  //     fotoPerfil: '',
  //     nroDocumento: '',
  //     idDocumento: 0,
  //     nombres: '',
  //     apellidos: '',
  //     fechaNacimiento: '',
  //     nombreTipoDoc: '',
  //     nombreListaPrecio: '',
  //     label: '',
  //     value: 0,
  //     idDatosPersona: 0,
  //     correo: '',
  //     numero: '',
  //     idUbigeo: null,
  //     ubigeo: '',
  //     direccion: '',
  //     referencia: '',
  //     idCorreo: 0,
  //     idDireccion: 0,
  //     idTelefono: 0,
  //     idDatoGeneral: 0,
  //     rucAfiliada: '',
  //     razonSocialAfiliada: '',
  //     direccionAfiliada: '',
  //   ),
  // );  
  
  final address = '${getCompanyAddressForDetail(order.details!.first, order, customersProvider)}';
  print('Address: $address');

  final selectedProducts = (order.details ?? []).map((detail) {
    Product? productFound;
    try {
      productFound = productsProvider.products.firstWhere(
        (p) => p.idProduct == detail.idProduct,
      );
    } catch (e) {
      productFound = null;
    }

    final product = productFound ??
        Product(
          idProduct: detail.idProduct!,
          productName: 'Producto no encontrado',
          animalType: '',
          productType: '',
          price: detail.unitPrice,
          unidadMedida: '',
          state: 0,
        );

    return ProductSelection(
      product: product,
      quantity: detail.quantity,
    );
  }).toList();
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Resumen del Pedido:', style: AppTextStyles.strong),
          const SizedBox(height: 5),
          ResumeProduct(selectedProducts: selectedProducts),
          const SizedBox(height: 5),
          _buildPagoRow(screenWidth),
          const SizedBox(height: 10),
          _buildEntregaSection(screenWidth, customersProvider),
          const SizedBox(height: 10),
          Text('Ubicación Geográfica', style: AppTextStyles.strong),
          const SizedBox(height: 10),
          _buildMapBox(address),
        ],
      ),
    );
  }

  Widget _buildPagoRow(double screenWidth) => Row(
    children: [
      Text('Tipo de Pago', style: AppTextStyles.strong),
      SizedBox(width: min(screenWidth * 0.088, 350)),
      Text(order.paymentMethod ?? "No tiene", style: AppTextStyles.weak),
    ],
  );

  Widget _buildEntregaSection(double screenWidth, CustomersProvider customersProvider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Datos de Entrega', style: AppTextStyles.strong),
          ],
        ),
        SizedBox(width: screenWidth * 0.040),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('Lugar:', style: AppTextStyles.weak),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      (order.details != null && order.details!.isNotEmpty)
                        ? (getCompanyAddressForDetail(order.details!.first, order, customersProvider) ?? '-')
                        : 'Sin dirección fiscal',
                      style: AppTextStyles.weak,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('Fecha:', style: AppTextStyles.weak),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      order.deliveryDate != null
                          ? DateFormat('dd/MM/yy').format(order.deliveryDate!)
                          : '-',
                      style: AppTextStyles.weak,
                    ),
                  )
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('Hora:', style: AppTextStyles.weak),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      order.deliveryTime != null
                          ? formatTimeOfDay12h(order.deliveryTime!)
                          : '-',
                      style: AppTextStyles.weak,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('Observación:', style: AppTextStyles.weak),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      order.additionalInformation ?? '-',
                      style: AppTextStyles.weak,
                      overflow: TextOverflow.visible,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMapBox(String address) {
    return FutureBuilder<latlng.LatLng?>(
      future: getLatLngFromAddress(address),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 150,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final coords = snapshot.data;

        if (coords == null) {
          return const SizedBox(
            height: 150,
            child: Center(child: Text('No se pudo obtener la ubicación')),
          );
        }

        return SizedBox(
          height: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: fmap.FlutterMap(
              options: fmap.MapOptions(
                initialCenter: latlng.LatLng(coords.latitude, coords.longitude),
                initialZoom: 14,
              ),
              children: [
                fmap.TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.app',
                ),
                fmap.MarkerLayer(
                  markers: [
                    fmap.Marker(
                      point: latlng.LatLng(coords.latitude, coords.longitude),
                      child: const Icon(Icons.location_pin, color: Colors.red, size: 30),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<latlng.LatLng?> getLatLngFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return latlng.LatLng(locations.first.latitude, locations.first.longitude);
      }
    } catch (e) {
      debugPrint('Error obteniendo coordenadas: $e');
    }
    return null;
  }
}

String formatTimeOfDay12h(TimeOfDay time) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return DateFormat.jm().format(dt); // Ej: "1:45 PM"
}

String? getCompanyAddressForDetail(OrderDetail detail, Order order, CustomersProvider customersProvider) {
  final customer = customersProvider.customers.firstWhere(
    (c) => c.idCliente == order.idCustomer,
    orElse: () => Customer(
      idCliente: 0,
      idListaPrecio: 0,
      estado: 0,
      fechaCreado: '',
      fotoPerfil: '',
      nroDocumento: '',
      idDocumento: 0,
      nombres: '',
      apellidos: '',
      fechaNacimiento: '',
      nombreTipoDoc: '',
      nombreListaPrecio: '',
      label: '',
      value: 0,
      idDatosPersona: 0,
      correo: '',
      numero: '',
      idUbigeo: null,
      ubigeo: '',
      direccion: '',
      referencia: '',
      idCorreo: 0,
      idDireccion: 0,
      idTelefono: 0,
      idDatoGeneral: 0,
      rucAfiliada: '',
      razonSocialAfiliada: '',
      direccionAfiliada: '',
    ),
  );

  final company = customer.direccionAfiliada;

  return company.isEmpty ? null : company;
}

class AppTextStyles {
  static const base = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 10,
    color: AppColors.darkGrey,
    fontWeight: FontWeight.w400,
  );
  static final weak = base.copyWith(fontWeight: FontWeight.w300);
  static final strong = base.copyWith();
  static final title = base.copyWith(fontSize: 16, fontWeight: FontWeight.w600);
  static final subtitle = base.copyWith(fontSize: 14, fontWeight: FontWeight.w500);
  static final date = base.copyWith(fontSize: 12, fontWeight: FontWeight.w300);
  static final itemTable = base.copyWith(fontSize: 12);

  static TextStyle estadoTextStyle(String tipoEstado) {
    Color color;
    switch (tipoEstado.toUpperCase()) {
      case 'PLANIFICADO':
        color = AppColors.blue;
        break;
      case 'DESPACHO':
        color = AppColors.orange;
        break;
      case 'ENTREGADO':
        color = AppColors.green;
        break;
      case 'NO ENTREGADO':
        color = AppColors.red;
        break;
      default:
        color = AppColors.darkGrey;
    }
    return base.copyWith(fontSize: 10, color: color, fontWeight: FontWeight.w400);
  }
}

class AppColors {
  static const red = Color(0xFFE74C3C);
  static const green = Color(0xFF2ECC71);
  static const darkGrey = Color(0xFF333333);
  static const grey = Color(0xFFBDBDBD);
  static const lightGrey = Color(0xFFECEFF1);
  static const blue = Color.fromARGB(255, 54, 114, 245);
  static const orange = Color.fromARGB(255, 241, 220, 25);
}