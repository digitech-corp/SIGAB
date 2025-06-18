import 'dart:convert';
import 'dart:io';

import 'package:balanced_foods/models/customer.dart';
import 'package:balanced_foods/providers/companies_provider.dart';
import 'package:balanced_foods/providers/customers_provider.dart';
import 'package:balanced_foods/providers/departments_provider.dart';
import 'package:balanced_foods/providers/districts_provider.dart';
import 'package:balanced_foods/providers/orders_provider.dart';
import 'package:balanced_foods/providers/provinces_provider.dart';
import 'package:balanced_foods/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';

class TransportScreen extends StatefulWidget {
  const TransportScreen({super.key});

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  DateTime selectedDate = DateTime.now();

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
    }
  }

  

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final orders = ordersProvider.orders;
    final customersProvider = Provider.of<CustomersProvider>(context);
    final companiesProvider = Provider.of<CompaniesProvider>(context);
    final departmentsProvider = Provider.of<DepartmentsProvider>(context);
    final provincesProvider = Provider.of<ProvincesProvider>(context);
    final districtsProvider = Provider.of<DistrictsProvider>(context);
    final customers = customersProvider.customers;
    final isLoading = ordersProvider.isLoading ||
                  customersProvider.isLoading ||
                  companiesProvider.isLoading;
    final filteredOrders = orders.where((order) {
      final delivery = order.dateCreated;
      return delivery != null &&
          delivery.year == selectedDate.year &&
          delivery.month == selectedDate.month &&
          delivery.day == selectedDate.day;
    }).toList();
    
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
                      MaterialPageRoute(builder: (context) => LoginScreen()),
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
                              customer = customers.firstWhere((c) => c.idCustomer == firstDetail);
                            } catch (_) {
                              customer = null;
                            }

                            String persona = '--';
                            String empresa = '--';
                            String fullAddress = '--';
                            String customerPhone = '--';
                            if (customer != null) {
                              persona = customer.customerName;
                              empresa = companiesProvider.getCompanyNameById(customer.idCompany);
                              customerPhone = customer.customerPhone;
                              String departmentName = departmentsProvider.getDepartmentName(customer.idDepartment);
                              String provinceName = provincesProvider.getProvinceName(customer.idProvince);
                              String districtName= districtsProvider.getDistrictName(customer.idDistrict);
                              fullAddress = '${customer.customerAddress}, ${districtName}, ${provinceName}, ${departmentName}';
                            }
                            
                            final codPedido = 'PEDIDO N° ${order.idOrder.toString().padLeft(2, '0')}-2025';

                            return Row(
                              children: [
                                Expanded(
                                  child: OrderCard(
                                    empresa: empresa,
                                    persona: persona,
                                    customerPhone: customerPhone,
                                    codPedido: codPedido,
                                    fullAddress: fullAddress,
                                  ),
                                ),
                              ],
                            );
                          },
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
  final customerPhone;
  final codPedido;
  final fullAddress;
  const OrderCard({super.key, required this.empresa, required this.persona, required this.customerPhone, required this.codPedido, required this.fullAddress});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(widget.empresa, style: AppTextStyles.company),
                        const SizedBox(height: 2),
                        Text(widget.persona, style: AppTextStyles.orderData),
                        const SizedBox(height: 2),
                        Text(widget.codPedido, style: AppTextStyles.orderData),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      IconButton(
                        icon: SizedBox(
                          width: 20,
                          height: 20,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            iconSize: 20,
                            visualDensity: VisualDensity.compact,
                            icon: SizedBox(
                              width: 16,
                              height: 16,
                              child: Image.asset('assets/images/phone.png', color: AppColors.orange),
                            ),
                            onPressed: () async {
                              final String phone = '+51${widget.customerPhone}';
                              final Uri callUri = Uri(scheme: 'tel', path: phone);
                              if (await canLaunchUrl(callUri)) {
                                await launchUrl(callUri);
                              }
                            },
                          ),
                          IconButton(
                            iconSize: 20,
                            visualDensity: VisualDensity.compact,
                            icon: SizedBox(
                              width: 16,
                              height: 16,
                              child: Image.asset('assets/images/whatsapp.png', color: AppColors.orange),
                            ),
                            onPressed: () async {
                              final String phone = '51${widget.customerPhone}';
                              final Uri whatsappUri = Uri.parse("https://wa.me/$phone");
                              if (await canLaunchUrl(whatsappUri)) {
                                await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 20,
                            visualDensity: VisualDensity.compact,
                            icon: SizedBox(
                              width: 16,
                              height: 16,
                              child: Image.asset('assets/images/documentation.png', color: Colors.black),
                            ),
                            onPressed: () {},
                          ),
                          Icon(Icons.attach_file, color: Colors.black, size: 18),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          height: 22,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return AppColors.orange;
                                }
                                return Colors.white;
                              }),
                              foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return Colors.white;
                                }
                                return AppColors.orange;
                              }),
                              side: WidgetStateProperty.all(
                                const BorderSide(color: AppColors.orange),
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                            child: Text('Detalles entrega', style: AppTextStyles.btnDetails),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_isExpanded) OrderExpandedDetail(),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderExpandedDetail extends StatefulWidget {
  const OrderExpandedDetail({super.key});

  @override
  State<OrderExpandedDetail> createState() => _OrderExpandedDetailState();
}

class _OrderExpandedDetailState extends State<OrderExpandedDetail> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  String? _base64Image;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await File(image.path).readAsBytes();
      final base64Image = base64Encode(bytes);
      setState(() {
        _selectedImage = image;
        _base64Image = base64Image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Detalles de Entrega', style: AppTextStyles.detailsHead),
        ),
        Divider(color: AppColors.lightGris, thickness: 1.0, height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Table(
            columnWidths: const {
              0: IntrinsicColumnWidth(),
              1: FlexColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: Text('Registro de Incidencias:', style: AppTextStyles.orderData),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextFormField(
                      style: TextStyle(fontSize: 10),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('Firma del cliente:', style: AppTextStyles.orderData),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextFormField(
                      style: TextStyle(fontSize: 10),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text('Fotos de entrega:', style: AppTextStyles.orderData),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: _selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(_selectedImage!.path),
                                fit: BoxFit.cover,
                                width: 25,
                                height: 25,
                              ),
                            )
                          : Container(
                              width: 25,
                              height: 25,
                              child: Icon(Icons.photo, color: Colors.grey),
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        const btnConfirmar(),
        const SizedBox(height: 10),
      ],
    );
  }
}

class btnConfirmar extends StatefulWidget {
  const btnConfirmar({super.key});
  @override
  State<btnConfirmar> createState() => _btnConfirmarState();
}

class _btnConfirmarState extends State<btnConfirmar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 22,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Registrado")),
                );
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              ),
              child: Text('Confirmar Entrega', style: AppTextStyles.btnConfirmar),
            ),
          ),
        ],
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
}

class AppColors {
  static const orange = Color(0xFFFF6600);
  static const gris = Color(0xFF333333);
  static const backgris = Color(0xFFECEFF1);
  static const lightGris = Color(0xFFBDBDBD);
}