import 'dart:convert';
import 'dart:io';
import 'package:balanced_foods/models/company.dart';
import 'package:balanced_foods/models/cuota.dart';
import 'package:balanced_foods/models/department.dart';
import 'package:balanced_foods/models/district.dart';
import 'package:balanced_foods/models/paymentInfo.dart';
import 'package:balanced_foods/models/province.dart';
import 'package:balanced_foods/providers/companies_provider.dart';
import 'package:balanced_foods/providers/customers_provider.dart';
import 'package:balanced_foods/providers/departments_provider.dart';
import 'package:balanced_foods/providers/districts_provider.dart';
import 'package:balanced_foods/providers/orders_provider.dart';
import 'package:balanced_foods/providers/products_provider.dart';
import 'package:balanced_foods/providers/provinces_provider.dart';
import 'package:balanced_foods/screens/Reportes/invoice_screen.dart';
import 'package:balanced_foods/screens/modulo_clientes/new_customer_screen.dart';
import 'package:balanced_foods/screens/modulo_pedidos/part_order.dart';
import 'package:flutter/material.dart';
import 'package:balanced_foods/models/customer.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
      final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
      productsProvider.fetchProducts();
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
            title: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                Positioned(
                  left: 0,
                  top: 50,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
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
                         showEditCustomerDialog(context, widget.customer, (updatedCustomer) {
                          print('Cliente actualizado: ${updatedCustomer.customerName}');
                        });
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

  void showEditCustomerDialog(BuildContext context, Customer customer, Function(Customer) onSave) {
    final _formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: customer.customerName);
    final dniController = TextEditingController(text: customer.dni);
    final phoneController = TextEditingController(text: customer.customerPhone);
    final emailController = TextEditingController(text: customer.customerEmail);
    final addressController = TextEditingController(text: customer.customerAddress);
    final referenceController = TextEditingController(text: customer.customerReference);

    final departmentsProvider = Provider.of<DepartmentsProvider>(context, listen: false);
    final departments = departmentsProvider.departments;
    final provincesProvider = Provider.of<ProvincesProvider>(context, listen: false);
    final provinces = provincesProvider.provinces;
    final districtsProvider = Provider.of<DistrictsProvider>(context, listen: false);
    final districts = districtsProvider.districts;
    final companiesProvider = Provider.of<CompaniesProvider>(context, listen: false);
    final companies = companiesProvider.companies;
    final company = companiesProvider.getCompanyNameById(customer.idCompany);
    final companyController = TextEditingController(text: company);

    showDialog(
      context: context,
      builder: (context) {
        // Variables de estado local para el diálogo
        XFile? _selectedImage;
        String? _base64Image;
        final ImagePicker _picker = ImagePicker();

        String? selectedDepartment = departmentsProvider.getDepartmentName(customer.idDepartment);
        String? selectedProvince = provincesProvider.getProvinceName(customer.idProvince);
        String? selectedDistrict = districtsProvider.getDistrictName(customer.idDistrict);

        return StatefulBuilder(
          builder: (context, setState) {
            // Filtrado dinámico de provincias y distritos
            final filteredProvinces = selectedDepartment == null
                ? []
                : provincesProvider.getProvincesByDepartment(
                    departments.firstWhere((d) => d.department == selectedDepartment).idDepartment,
                  );
            final filteredDistricts = selectedProvince == null
                ? []
                : districts.where((d) {
                    final province = filteredProvinces.firstWhere(
                      (p) => p.province == selectedProvince,
                      orElse: () => Province(idProvince: 0, province: '', idDepartment: 0),
                    );
                    return d.idProvince == province.idProvince;
                  }).toList();

            // Selección de imagen
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

            Widget _buildCustomerImage(String? imageUrl) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(58),
                            child: Image.file(
                              File(_selectedImage!.path),
                              fit: BoxFit.cover,
                            ),
                          )
                        : (imageUrl != null && imageUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(58),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.grey,
                              )),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[700],
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 10),
              title: Text('Editar Cliente', style: AppTextStyles.editTitle),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildCustomerImage(customer.customerImage),
                      const SizedBox(height: 10),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Nombre',
                          labelStyle: AppTextStyles.editVars,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 1),
                        ),
                        style: AppTextStyles.base,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: dniController,
                              decoration: InputDecoration(
                                labelText: 'Dni',
                                labelStyle: AppTextStyles.editVars,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 1),
                              ),
                              style: AppTextStyles.base,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(8),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: phoneController,
                              decoration: InputDecoration(
                                labelText: 'Teléfono',
                                labelStyle: AppTextStyles.editVars,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 1),
                              ),
                              style: AppTextStyles.base,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(9),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Correo',
                          labelStyle: AppTextStyles.editVars,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 1),
                        ),
                        style: AppTextStyles.base,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingresa un correo electrónico';
                          }
                          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Por favor, ingresa un correo electrónico válido';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                  
                      TextField(
                        controller: addressController,
                        decoration: InputDecoration(
                          labelText: 'Dirección',
                          labelStyle: AppTextStyles.editVars,
                        ),
                        style: AppTextStyles.base,
                      ),
                      TextField(
                        controller: referenceController,
                        decoration: InputDecoration(
                          labelText: 'Referencia',
                          labelStyle: AppTextStyles.editVars,
                        ),
                        style: AppTextStyles.base,
                      ),
                      TextField(
                        controller: companyController,
                        decoration: InputDecoration(
                          labelText: 'Empresa',
                          labelStyle: AppTextStyles.editVars,
                        ),
                        style: AppTextStyles.base,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Departamento', style: AppTextStyles.selectVars),
                        ],
                      ),
                      BuildSelect(
                        selectedValue: selectedDepartment,
                        options: departments.map((d) => d.department).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDepartment = value;
                            selectedProvince = null;
                            selectedDistrict = null;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, selecciona un departamento';
                          }
                          return null;
                        },
                        hintText: 'Departamento',
                      ),
                      const SizedBox(height: 7),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Provincia', style: AppTextStyles.selectVars),
                                const SizedBox(height: 5),
                                BuildSelect(
                                  selectedValue: selectedProvince,
                                  options: filteredProvinces.map((p) => p.province.toString()).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedProvince = value;
                                      selectedDistrict = null;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, selecciona una provincia';
                                    }
                                    return null;
                                  },
                                  hintText: 'Provincia',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Distrito', style: AppTextStyles.selectVars),
                                const SizedBox(height: 5),
                                BuildSelect(
                                  selectedValue: selectedDistrict,
                                  options: filteredDistricts.map((d) => d.district.toString()).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedDistrict = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, selecciona un distrito';
                                    }
                                    return null;
                                  },
                                  hintText: 'Distrito',
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
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar', style: AppTextStyles.btn),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final selectedDepartmentObj = departments.firstWhere(
                        (d) => d.department == selectedDepartment,
                        orElse: () => Department(idDepartment: 0, department: ''),
                      );
                      final selectedDepartmentId = selectedDepartmentObj.idDepartment;
                      final selectedProvinceObj = provinces.firstWhere(
                        (d) => d.province == selectedProvince,
                        orElse: () => Province(idProvince: 0, province: '', idDepartment: 0),
                      );
                      final selectedProvinceId = selectedProvinceObj.idProvince;
                      final selectedDistrictObj = districts.firstWhere(
                        (d) => d.district == selectedDistrict,
                        orElse: () => District(idDistrict: 0, district: '', idProvince: 0),
                      );
                      final selectedDistrictId = selectedDistrictObj.idDistrict;
                      final companyNameObj = companies.firstWhere(
                        (c) => c.companyName == companyController.text,
                        orElse: () => Company(idCompany: 0, companyName: '', companyRUC: '', companyAddress: '', companyWeb: ''),
                      );
                      final companyId = companyNameObj.idCompany;

                      final updatedCustomer = customer.copyWith(
                        name: nameController.text,
                        dni_new: dniController.text,
                        image: _selectedImage != null ? _selectedImage.toString() : customer.customerImage,
                        phone: phoneController.text,
                        email: emailController.text,
                        address: addressController.text,
                        reference: referenceController.text,
                        company: companyId,
                        department: selectedDepartmentId,
                        province: selectedProvinceId,
                        district: selectedDistrictId,
                      );
                      onSave(updatedCustomer);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Editado correctamente")),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Guardar', style: AppTextStyles.btn),
                ),
              ],
            );
          },
        );
      },
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
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final customersProvider = Provider.of<CustomersProvider>(context);
    final companiesProvider = Provider.of<CompaniesProvider>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);
    final customerOrders = ordersProvider.getOrdersByCustomer(widget.customer.idCustomer!);

    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('RELACIÓN DE FACTURAS', style: AppTextStyles.cardTitle),
            Divider(color: AppColors.lightGris, thickness: 1.0, height: 25),
            customerOrders.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('No hay facturas registradas', style: AppTextStyles.bodyTable),
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
                            // Título de la factura/pedido
                            Text(
                              'Pedido ${order.idOrder ?? "-"}-2025',
                              style: AppTextStyles.base,
                            ),
                            Spacer(),
                            // Ícono de adjunto
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => InvoiceScreen(
                                    idOrder: order.idOrder ?? 0,
                                  )),
                                );
                              },
                              child: Icon(
                                Icons.attach_file,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Botón de WhatsApp
                            IconButton(
                              icon: SizedBox(
                                width: 20,
                                height: 20,
                                child: Image.asset('assets/images/whatsapp.png', color: Colors.black),
                              ),
                              onPressed: () async {
                                final customer = customersProvider.customers
                                    .firstWhere((c) => c.idCustomer == order.idCustomer);

                                // Mensaje por defecto
                                final mensaje = Uri.encodeComponent(
                                    'Hola ${customer.customerName}, te comparto la factura de tu pedido. Gracias por su compra.');

                                // Asegúrate de que el número esté en formato correcto
                                final numeroSinPrefijo = customer.customerPhone.replaceAll('+', '').replaceAll(' ', '');
                                final whatsappUrl = Uri.parse("https://wa.me/$numeroSinPrefijo?text=$mensaje");

                                if (await canLaunchUrl(whatsappUrl)) {
                                  await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('No se pudo abrir WhatsApp')),
                                  );
                                }
                              },
                            ),

                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
  Widget _creditsDetail() {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final customerOrders = ordersProvider
        .getOrdersByCustomer(widget.customer.idCustomer!)
        .where((order) => order.paymentMethod == 'Crédito')
        .toList();

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
                Text('Fecha', style: AppTextStyles.bodyTable),
                Text('Número Pedido', style: AppTextStyles.base),
                Text('F. Venc', style: AppTextStyles.bodyTable),
                Text('Monto', style: AppTextStyles.bodyTable),
                Text('Estado', style: AppTextStyles.bodyTable),
              ],
            ),
            Divider(color: AppColors.lightGris, thickness: 1.0, height: 2),
            const SizedBox(height: 10),
            customerOrders.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('No hay créditos registrados', style: AppTextStyles.bodyTable),
                  )
                : ListView.builder(
                    itemCount: customerOrders.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final order = customerOrders[index];
                      String fechaVenc = '--/--/--';
                      if (order.paymentInfo is CreditoPaymentInfo) {
                        final creditoInfo = order.paymentInfo as Cuota;
                        fechaVenc = DateFormat('dd/MM/yy').format(creditoInfo.fecha);
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.dateCreated != null
                                  ? DateFormat('dd/MM/yy').format(order.dateCreated!)
                                  : '--/--/--',
                              style: AppTextStyles.bodyTable,
                            ),
                            // Número de pedido
                            Text(
                              'Pedido ${order.idOrder ?? "-"}-2025',
                              style: AppTextStyles.bodyTable,
                            ),
                            // Fecha de vencimiento
                            Text(
                              fechaVenc,
                              style: AppTextStyles.bodyTable,
                            ),
                            // Monto
                            Text(
                              'S/. ${order.total.toStringAsFixed(2)}',
                              style: AppTextStyles.bodyTable,
                            ),
                            // Estado
                            order.paymentState == 'Pagado'
                                ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                                : const Icon(Icons.cancel, color: Colors.red, size: 20),
                          ],
                        ),
                      );
                    },
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

    Navigator.pop(context);

    registerOrder(
      context: context,
      idCustomer: idCustomer,
      receiptKey: _receiptKey,
      observationsKey: _observationsKey,
      paymentKey: _paymentKey,
      paymentInfoKey: _paymentKey,
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
  static final name = base.copyWith(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white);
  static final company = base.copyWith(fontSize: 12, color: Colors.black);
  static final cardTitle = base.copyWith();
  static final editTitle = base.copyWith(fontWeight: FontWeight.w600, color: AppColors.orange);
  static final editVars= base.copyWith(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black);
  static final selectVars= base.copyWith(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.black);
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


