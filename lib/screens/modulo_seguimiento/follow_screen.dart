import 'package:balanced_foods/models/company.dart';
import 'package:balanced_foods/models/customer.dart';
import 'package:balanced_foods/models/order.dart';
import 'package:balanced_foods/models/orderDetail.dart';
import 'package:balanced_foods/models/product.dart';
import 'package:balanced_foods/providers/companies_provider.dart';
import 'package:balanced_foods/providers/customers_provider.dart';
import 'package:balanced_foods/providers/districts_provider.dart';
import 'package:balanced_foods/providers/orders_provider.dart';
import 'package:balanced_foods/providers/products_provider.dart';
import 'package:balanced_foods/screens/modulo_pedidos/part_order.dart';
import 'package:balanced_foods/screens/modulo_pedidos/product_catalog_screen.dart';
import 'package:balanced_foods/screens/sales_module_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FollowScreen extends StatefulWidget {
  const FollowScreen({super.key});

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async{
      final customersProvider = Provider.of<CustomersProvider>(context, listen: false);
      final companiesProvider = Provider.of<CompaniesProvider>(context, listen: false);
      final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
      final districtsProvider = Provider.of<DistrictsProvider>(context, listen: false);

      await customersProvider.fetchCustomers();
      await companiesProvider.fetchCompanies();
      await ordersProvider.fetchOrders();
      await districtsProvider.fetchDistricts();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrdersProvider>(context).orders;
    final screenWidth = MediaQuery.of(context).size.width;
    final bodyPadding = screenWidth * 0.06;
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
              ...orders.asMap().entries.map((entry) {
                final index = entry.key;
                final order = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: OrderCard(order: order, index: index),
                );
              }).toList(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Pedidos del día', style: AppTextStyles.subtitle),
        Text(DateFormat('dd/MM/yyyy').format(DateTime.now()), style: AppTextStyles.date),
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          children: [
            Text('Item', style: AppTextStyles.itemTable),
          ],
        ),
        const SizedBox(width: 15),
        Column(
          children: [
            Text('N° Pedido', style: AppTextStyles.itemTable),
          ],
        ),
        const SizedBox(width: 15),
        Column(
          children: [
            Text('Estado', style: AppTextStyles.itemTable),
          ],
        ),
        const SizedBox(width: 15),
        Column(
          children: [
            Text('F. entrega', style: AppTextStyles.itemTable),
          ],
        ),
        const SizedBox(width: 20),
        Column(
          children: [
            Text('Lugar', style: AppTextStyles.itemTable),
          ],
        ),
        const SizedBox(width: 30),
        Column(
          children: [
            Text('Detalle', style: AppTextStyles.itemTable),
          ],
        ),
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

  String? getDistrictNameForOrder(Order order) {
    final customersProvider = Provider.of<CustomersProvider>(context, listen: false);
    final districtsProvider = Provider.of<DistrictsProvider>(context, listen: false);

    if (order.details.isEmpty) return null;

    final customerId = order.details.first.idCustomer;
    
    try {
      final customer = customersProvider.customers.firstWhere((c) => c.idCustomer == customerId);
      return districtsProvider.getDistrictName(customer.idDistrict);
    } catch (e) {
      return null;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          SizedBox(
            height: 30,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${(widget.index + 1).toString().padLeft(2, '0')}', style: AppTextStyles.weak),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('P-${widget.order.idOrder.toString().padLeft(2, '0')}-2025', style: AppTextStyles.weak),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.order.state}',
                        style: widget.order.state == 'Pendiente'
                            ? AppTextStyles.red
                            : AppTextStyles.green,
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.order.deliveryDate != null ? DateFormat('dd/MM/yy').format(widget.order.deliveryDate!) : "-"}',
                        style: AppTextStyles.weak,
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          getDistrictNameForOrder(widget.order) ?? "Sin distrito",
                          style: AppTextStyles.weak,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
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
                ],
              ),
            ),
          ),
          if (_isExpanded) OrderExpandedDetail(order: widget.order),
        ],
      ),
    );
  }
}

class OrderExpandedDetail extends StatelessWidget {
  final Order order;
  const OrderExpandedDetail({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final customersProvider = Provider.of<CustomersProvider>(context, listen: false);
    final companiesProvider = Provider.of<CompaniesProvider>(context, listen: false);
    final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    final screenWidth = MediaQuery.of(context).size.width;
    
    final selectedProducts = order.details.map((detail) {
      final product = productsProvider.products.firstWhere(
        (p) => p.idProduct == detail.idProducto,
        orElse: () => Product(
          idProduct: detail.idProducto,
          productName: 'Desconocido',
          animalType: 'Desconocido',
          productType: 'Desconocido',
          price: detail.unitPrice,
          state: false,
        ),
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
          _buildEntregaSection(screenWidth, customersProvider, companiesProvider),
          const SizedBox(height: 10),
          Text('Ubicación Geográfica', style: AppTextStyles.strong),
          const SizedBox(height: 10),
          _buildMapBox(),
        ],
      ),
    );
  }

  Widget _buildPagoRow(double screenWidth) => Row(
    children: [
      Text('Tipo de Pago', style: AppTextStyles.strong),
      SizedBox(width: min(screenWidth * 0.088, 350)),
      Text(order.paymentMethod, style: AppTextStyles.weak),
    ],
  );

  Widget _buildEntregaSection(double screenWidth, CustomersProvider customersProvider, CompaniesProvider companiesProvider) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(children: [Text('Datos de Entrega', style: AppTextStyles.strong)]),
      SizedBox(width: screenWidth * 0.040),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Lugar:', style: AppTextStyles.weak),
          SizedBox(height: 5),
          Text('Fecha:', style: AppTextStyles.weak),
          SizedBox(height: 5),
          Text('Hora:', style: AppTextStyles.weak),
          SizedBox(height: 5),
          Text('Observación', style: AppTextStyles.weak),
        ],
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(getCompanyAddressForDetail(order.details.first, customersProvider, companiesProvider) ?? 'Sin dirección fiscal', style: AppTextStyles.weak),
            SizedBox(height: 5),
            Text('${order.deliveryDate != null ? DateFormat('dd/MM/yy').format(order.deliveryDate!) : "-"}', style: AppTextStyles.weak),
            SizedBox(height: 5),
            Text(order.deliveryTime != null ? formatTimeOfDay12h(order.deliveryTime!) : '-', style: AppTextStyles.weak),
            SizedBox(height: 5),
            Text(order.additionalInformation!, style: AppTextStyles.weak),
          ],
        ),
      ),
    ],
  );

  Widget _buildMapBox() => Container(
    height: 150,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Image.asset('assets/images/map.png', fit: BoxFit.cover),
    ),
  );
}

String formatTimeOfDay12h(TimeOfDay time) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return DateFormat.jm().format(dt); // Ej: "1:45 PM"
}

String? getCompanyAddressForDetail(
  OrderDetail detail,
  CustomersProvider customersProvider,
  CompaniesProvider companiesProvider,
) {
  final customer = customersProvider.customers.firstWhere(
    (c) => c.idCustomer == detail.idCustomer,
    orElse: () => Customer(idCustomer: 0, customerName: '', customerImage: '', customerPhone: '', customerEmail: '', customerAddress: '', customerReference: '', idCompany: 0, idDepartment: 0, idProvince: 0, idDistrict: 0),
  );

  final company = companiesProvider.companies.firstWhere(
    (c) => c.idCompany == customer.idCompany,
    orElse: () => Company(idCompany: 0, companyRUC: '', companyName: 'Desconocido', companyAddress: '', companyWeb: ''),
  );

  return company.companyAddress.isEmpty ? null : company.companyAddress;
}

class AppTextStyles {
  static const base = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 10,
    color: AppColors.darkGrey,
    fontWeight: FontWeight.w400
  );
  static final weak = base.copyWith(fontWeight: FontWeight.w300);
  static final strong = base.copyWith();
  static final title = base.copyWith(fontSize: 16,fontWeight: FontWeight.w600);
  static final subtitle = base.copyWith(fontSize: 14,fontWeight: FontWeight.w500);
  static final date = base.copyWith(fontSize: 12,fontWeight: FontWeight.w300);
  static final itemTable = base.copyWith(fontSize: 12);
  static final red = base.copyWith(color: AppColors.red);
  static final green = base.copyWith(color: AppColors.green);
}

class AppColors {
  static const red = Color(0xFFE74C3C);
  static const green = Color(0xFF2ECC71);
  static const darkGrey = Color(0xFF333333);
  static const grey = Color(0xFFBDBDBD);
  static const lightGrey = Color(0xFFECEFF1);
}