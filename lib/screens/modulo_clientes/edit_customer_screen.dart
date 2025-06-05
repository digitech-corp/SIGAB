import 'package:balanced_foods/providers/departments_provider.dart';
import 'package:balanced_foods/providers/districts_provider.dart';
import 'package:balanced_foods/providers/orders_provider.dart';
import 'package:balanced_foods/providers/products_provider.dart';
import 'package:balanced_foods/providers/provinces_provider.dart';
import 'package:balanced_foods/screens/modulo_pedidos/part_order.dart';
import 'package:flutter/material.dart';
import 'package:balanced_foods/models/customer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EditCustomerScreen extends StatefulWidget {
  final Customer customer;
  final String companyName;

  const EditCustomerScreen({
    Key? key,
    required this.customer,
    required this.companyName,
  }) : super(key: key);

  @override
  State<EditCustomerScreen> createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<DepartmentsProvider>(context, listen: false).fetchDepartments();
      Provider.of<ProvincesProvider>(context, listen: false).fetchProvinces();
      Provider.of<DistrictsProvider>(context, listen: false).fetchDistricts();
      Provider.of<OrdersProvider>(context, listen: false).fetchOrders();
      Provider.of<ProductsProvider>(context, listen: false).setCurrentCustomer(widget.customer.idCustomer!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final departmentsProvider = Provider.of<DepartmentsProvider>(context);
    final departmentName = departmentsProvider.getDepartmentName(widget.customer.idDepartment);
    final provincesProvider = Provider.of<ProvincesProvider>(context);
    final provinceName = provincesProvider.getProvinceName(widget.customer.idProvince);
    final districtsProvider = Provider.of<DistrictsProvider>(context);
    final districtName = districtsProvider.getDistrictName(widget.customer.idDistrict);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          child: AppBar(
            toolbarHeight: double.infinity,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.orange,
            title: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 58,
                    backgroundImage: widget.customer.customerImage.isNotEmpty
                        ? NetworkImage(widget.customer.customerImage)
                        : null,
                    backgroundColor: Colors.grey[300],
                    child: widget.customer.customerImage.isEmpty
                        ? Icon(
                            Icons.person,
                            size: 100,
                            color: AppColors.gris,
                          )
                        : null,
                  ),
                  Text(widget.customer.customerName, style: AppTextStyles.name),
                  Text(widget.companyName, style: AppTextStyles.company),
                ],
              ),
            ),
          ),
        ),
      ),
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: SizedBox(
                          width: 20,
                          height: 20,
                          child: Image.asset('assets/images/phone.png', color: Colors.black),
                        ),
                        onPressed: () async {
                          final String phone = '+51${widget.customer.customerPhone}';
                          final Uri callUri = Uri(scheme: 'tel', path: phone);
                          if (await canLaunchUrl(callUri)) {
                            await launchUrl(callUri);
                          } else {
                            debugPrint('No se pudo lanzar $callUri');
                          }
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          widget.customer.customerPhone.length == 9
                          ? '${widget.customer.customerPhone.substring(0, 3)} ${widget.customer.customerPhone.substring(3, 6)} ${widget.customer.customerPhone.substring(6)}'
                          : widget.customer.customerPhone,
                          style: AppTextStyles.base
                        ),
                        Text('Celular', style: AppTextStyles.subtitle),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: SizedBox(
                          width: 20,
                          height: 20,
                          child: Image.asset('assets/images/whatsapp.png', color: Colors.black),
                        ),
                        onPressed: () async {
                          final String phone = '51${widget.customer.customerPhone}';
                          final Uri whatsappUri = Uri.parse("https://wa.me/$phone");
                          if (await canLaunchUrl(whatsappUri)) {
                            await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
                          } else {
                            debugPrint('No se pudo abrir WhatsApp para $phone');
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: SizedBox(
                          width: 20,
                          height: 20,
                          child: Image.asset(
                            'assets/images/gmail.png',
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () async {
                          final String customerEmail = widget.customer.customerEmail;
                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: customerEmail,
                          );

                          if (await canLaunchUrl(emailLaunchUri)) {
                            await launchUrl(emailLaunchUri);
                          } else {
                            debugPrint('No se pudo abrir el cliente de correo');
                          }
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(widget.customer.customerEmail, style: AppTextStyles.base),
                        Text('Particular', style: AppTextStyles.subtitle),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: SizedBox(
                          width: 20,
                          height: 20,
                          child: Icon(
                            Icons.navigate_next,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () async {
                          final String customerEmail = widget.customer.customerEmail;
                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: customerEmail,
                          );

                          if (await canLaunchUrl(emailLaunchUri)) {
                            await launchUrl(emailLaunchUri);
                          } else {
                            debugPrint('No se pudo abrir el cliente de correo');
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: SizedBox(
                          width: 20,
                          height: 20,
                          child: Image.asset(
                            'assets/images/gps.png',
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () async {
                          final String fullAddress =
                              '${widget.customer.customerAddress}, $districtName, $provinceName, $departmentName';

                          final Uri mapsUri = Uri.parse(
                            'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(fullAddress)}',
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          '${widget.customer.customerAddress} (${widget.customer.customerReference})',
                          style: AppTextStyles.base,
                          softWrap: true,
                        ),
                        Text(
                          '$districtName, $provinceName, $departmentName',
                          style: AppTextStyles.base
                        ),
                        Text('Dirección Fiscal', style: AppTextStyles.subtitle),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: SizedBox(
                          width: 20,
                          height: 20,
                          child: Icon(
                            Icons.navigate_next,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () async {
                          final String fullAddress =
                              '${widget.customer.customerAddress}, ${widget.customer.customerReference}, $districtName, $provinceName, $departmentName';

                          final Uri mapsUri = Uri.parse(
                            'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(fullAddress)}',
                          );

                          if (await canLaunchUrl(mapsUri)) {
                            await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
                          } else {
                            debugPrint('No se pudo abrir Google Maps');
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                RecordCard(customer: widget.customer),
              ],
            ),
          ],
        ),
        
      ),
    );
  }
}

class RecordCard extends StatefulWidget {
  final Customer customer;
  
  const RecordCard({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  State<RecordCard> createState() => _RecordCardState();
}

class _RecordCardState extends State<RecordCard> {
  int _selectedIndex = 0;
  final List<String> _titulos = ['Historial', 'Pedidos', 'Facturación', 'Créditos'];
  final TextEditingController _searchController = TextEditingController();
  
  final _observationsKey = GlobalKey<ObservationsState>();
  final _paymentKey = GlobalKey<PaymentMethodState>();
  final _receiptKey = GlobalKey<ReceiptTypeState>();

  void _resetForm() {
    setState(() {
      _searchController.clear();
    });

    final provider = Provider.of<ProductsProvider>(context, listen: false);
    provider.clearSelections();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, right: 18, left: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_titulos.length, (index) {
                final bool isSelected = _selectedIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected 
                        ? null
                        : null,
                      border: isSelected
                          ? Border.all(color: AppColors.lightGris)
                          : Border.all(color: AppColors.lightGris),
                    ),
                    child: Text(
                      _titulos[index],
                       style: AppTextStyles.titleCards(isSelected),
                    ),
                  ),
                );
              }),
            ),
          ),
          const Divider(color: AppColors.lightGris, thickness: 1.0, height: 0,),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              children: [
                IndexedStack(
                  index: _selectedIndex,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _recordDetail()),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: _ordersDetail()),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: _collectionsDetail()),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: _creditsDetail()),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _recordDetail() {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final customerOrders = ordersProvider.getOrdersByCustomer(widget.customer.idCustomer!);
    return Card(
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Fecha', style: AppTextStyles.headerTable),
                  Text('Pedido', style: AppTextStyles.headerTable),
                  Text('Monto', style: AppTextStyles.headerTable),
                  Text('T. Pago', style: AppTextStyles.headerTable),
                  Text('Estado', style: AppTextStyles.headerTable)
                ],
              ),
              Divider(color: AppColors.lightGris, thickness: 1.0, height: 1,),
              const SizedBox(height: 8),
              customerOrders.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('No hay pedidos registrados', style: AppTextStyles.bodyTable),
                  )
                : ListView.builder(
                    itemCount: customerOrders.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final order = customerOrders[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                order.dateCreated != null
                                  ? DateFormat('dd/MM/yy').format(order.dateCreated!)
                                  : 'Sin fecha',
                                style: AppTextStyles.bodyTable,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${order.idOrder ?? "-"}-2025',
                                style: AppTextStyles.bodyTable,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${order.total.toStringAsFixed(2)}',
                                style: AppTextStyles.bodyTable,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                order.paymentMethod,
                                style: AppTextStyles.bodyTable,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                order.paymentState ?? '-',
                                style: AppTextStyles.bodyTable,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  SizedBox(
                    width: 282,
                    height: 37,
                    child: ElevatedButton(
                      onPressed: () {
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: AppColors.orange, 
                            width: 1, 
                          ),
                        ),
                      ),
                      child: Text('Editar Contacto', style: AppTextStyles.btn),
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
  Widget _ordersDetail() {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: SizedBox(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              receiptType(key: _receiptKey),
              const SizedBox(height: 20),
              partOrder(idCustomer: widget.customer.idCustomer!),
              const SizedBox(height: 15),
              SearchProduct(idCustomer: widget.customer.idCustomer!),
              const SizedBox(height: 20),
              ResumeProduct(selectedProducts: Provider.of<ProductsProvider>(context).selectedProducts,),
              const SizedBox(height: 10),
              paymentMethod(key: _paymentKey),
              observations(key: _observationsKey),
              const SizedBox(height: 20),
              buttonRegisterOrder(onPressed: _registerOrder),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
  Widget _collectionsDetail() {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('RELACIÓN DE FACTURAS', style: AppTextStyles.cardTitle),
            Divider(color: AppColors.lightGris, thickness: 1.0, height: 25),
            Row(
              children: [
                Text('Pedido 19-2025', style: AppTextStyles.base),
                Spacer(),
                Icon(
                  Icons.attach_file,
                  color: Colors.black,
                  size: 20
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: SizedBox(
                    width: 20,
                    height: 20,
                    child: Image.asset('assets/images/whatsapp.png', color: Colors.black),
                  ),
                  onPressed: () {
                    debugPrint('Abriendo WhatsApp');
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text('Pedido 35-2025', style: AppTextStyles.base),
                Spacer(),
                Icon(
                  Icons.attach_file,
                  color: Colors.black,
                  size: 20
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: SizedBox(
                    width: 20,
                    height: 20,
                    child: Image.asset('assets/images/whatsapp.png', color: Colors.black),
                  ),
                  onPressed: () {
                    debugPrint('Abriendo WhatsApp');
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  Widget _creditsDetail() {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('RELACIÓN DE CRÉDITOS', style: AppTextStyles.cardTitle),
            Divider(color: AppColors.lightGris, thickness: 1.0, height: 5),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Fecha  ', style: AppTextStyles.bodyTable),
                Text('  Número Pedido', style: AppTextStyles.base),
                Text('F. Venc', style: AppTextStyles.bodyTable),
                Text('Monto', style: AppTextStyles.bodyTable),
                Text('Estado', style: AppTextStyles.bodyTable),
              ],
            ),
            Divider(color: AppColors.lightGris, thickness: 1.0, height: 2),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('15/03/25', style: AppTextStyles.bodyTable),
                Text('Pedido 19-2025', style: AppTextStyles.bodyTable),
                Text('22/03/25', style: AppTextStyles.bodyTable),
                Text('S/. 357.90', style: AppTextStyles.bodyTable),
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('18/03/25', style: AppTextStyles.bodyTable),
                Text('Pedido 45-2025', style: AppTextStyles.bodyTable),
                Text('25/03/25', style: AppTextStyles.bodyTable),
                Text('S/. 357.90', style: AppTextStyles.bodyTable),
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: 20
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _registerOrder() {
    final idCustomer = widget.customer.idCustomer;
    final products = Provider.of<ProductsProvider>(context, listen: false);
    final selectedProducts = products.selectedProducts;
    final paymentMethod = _paymentKey.currentState?.selectedPaymentMethod;
    final receiptType = _receiptKey.currentState?.selectedReceiptType;

    // Validar tipo de recibo
    if (receiptType == null || receiptType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selecciona un tipo de recibo")),
      );
      return;
    }

    // Validar productos
    if (selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selecciona al menos un producto")),
      );
      return;
    }

    // Validar método de pago
    if (paymentMethod == null || paymentMethod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selecciona un método de pago")),
      );
      return;
    }

    // Si todo es válido, cerrar modal y registrar
    Navigator.pop(context);

    registerOrder(
      context: context,
      idCustomer: idCustomer,
      receiptKey: _receiptKey,
      observationsKey: _observationsKey,
      paymentKey: _paymentKey,
      resetForm: _resetForm,
    );
  }
}

class AppTextStyles {
  static const base = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w300,
    fontSize: 13,
    color: AppColors.gris
  );
  static final name = base.copyWith(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white);
  static final company = base.copyWith(fontSize: 12,color: Colors.black);
  static final cardTitle = base.copyWith();
  static final subtitle = base.copyWith(fontSize: 10, color: AppColors.lightGris);
  static final btn = base.copyWith(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.orange);
  static final headerTable = base.copyWith(fontSize: 11, fontWeight: FontWeight.w400);
  static final bodyTable = base.copyWith(fontSize: 11);
  static TextStyle titleCards(bool isSelected) {
    return base.copyWith(
      color: isSelected ? AppColors.orange : AppColors.lightGris,
    );
  }
}

class AppColors {
  static const orange = Color(0xFFFF6600);
  static const gris = Color(0xFF333333);
  static const lightGris = Color(0xFFBDBDBD);
}


