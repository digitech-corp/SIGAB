import 'package:balanced_foods/providers/departments_provider.dart';
import 'package:balanced_foods/providers/districts_provider.dart';
import 'package:balanced_foods/providers/products_provider.dart';
import 'package:balanced_foods/providers/provinces_provider.dart';
import 'package:balanced_foods/screens/modulo_pedidos/part_order.dart';
import 'package:flutter/material.dart';
import 'package:balanced_foods/models/customer.dart';
import 'package:provider/provider.dart';

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
    
    final products = Provider.of<ProductsProvider>(context, listen: false);
    products.setCurrentCustomer(widget.customer.idCustomer!);
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
                        onPressed: () {
                          debugPrint('Llamando...');
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
                          style: AppTextStyles.customerData
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
                        onPressed: () {
                          debugPrint('Abriendo WhatsApp');
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
                        onPressed: () {
                          debugPrint('Abriendo Gmail');
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(widget.customer.customerEmail, style: AppTextStyles.customerData),
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
                        onPressed: () {
                          debugPrint('Abriendo Gmail');
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
                        onPressed: () {
                          debugPrint('Viendo Ubicación');
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
                          style: AppTextStyles.customerData,
                          softWrap: true,
                        ),
                        Text(
                          '$districtName, $provinceName, $departmentName',
                          style: AppTextStyles.customerData
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
                        onPressed: () {
                          debugPrint('Viendo Ubicación');
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
  bool _isChecked = false;

  final _observationsKey = GlobalKey<ObservationsState>();
  final _paymentKey = GlobalKey<PaymentMethodState>();

  void _resetForm() {
    setState(() {
      _searchController.clear();
      _isChecked = false;
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
          // Botones de filtro
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_titulos.length, (index) {
                final bool isSelected = _selectedIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        'FACTURA:',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 25,
                        child: Transform.scale(
                          scale: 0.8,
                          child: Checkbox(
                            value: _isChecked, 
                            activeColor: Color(0xFF333333),
                            checkColor: Colors.white,
                            onChanged: (value) {
                              setState(() {
                                _isChecked = value ?? false;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              partOrder(),
              searchProduct(),
              resumeProduct(),
              paymentMethod(key: _paymentKey),
              observations(key: _observationsKey),
              buttonRegisterOrder(onPressed: _registerOrder),
            ],
          ),
        ),
      ),
    );
  }
  Widget _collectionsDetail() {
    return Card(
      color: Color(0xFFD9D9D9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        height: 80,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Facturación')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _creditsDetail() {
    return Card(
      color: Color(0xFFD9D9D9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        height: 80,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Créditos')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _registerOrder() {
    final idCustomer = widget.customer.idCustomer;
    final products = Provider.of<ProductsProvider>(context, listen: false);
    final selectedProducts = products.selectedProducts;
    final paymentMethod = _paymentKey.currentState?.selectedPaymentMethod;

    final receiptType = _isChecked ? "FACTURA" : "BOLETA";

    // Validar cliente
    if (idCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No se reconoció el cliente")),
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
      observationsKey: _observationsKey,
      paymentKey: _paymentKey,
      resetForm: _resetForm,
      receiptType: receiptType,
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
  static final customerData = base.copyWith();
  static final subtitle = base.copyWith(fontSize: 10, color: AppColors.lightGris);
  static final btn = base.copyWith(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.orange);
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
