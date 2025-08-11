import 'dart:convert';
import 'dart:io';
import 'package:balanced_foods/models/opcionCatalogo.dart';
import 'package:balanced_foods/models/ubigeo.dart';
import 'package:balanced_foods/providers/configuraciones_provider.dart';
import 'package:balanced_foods/providers/customers_provider.dart';
import 'package:balanced_foods/providers/departments_provider.dart';
import 'package:balanced_foods/providers/districts_provider.dart';
import 'package:balanced_foods/providers/facturas_provider.dart';
import 'package:balanced_foods/providers/orders_provider.dart';
import 'package:balanced_foods/providers/products_provider.dart';
import 'package:balanced_foods/providers/provinces_provider.dart';
import 'package:balanced_foods/providers/ubigeos_provider.dart';
import 'package:balanced_foods/providers/users_provider.dart';
import 'package:balanced_foods/screens/Vendedor/modulo_clientes/new_customer_screen.dart';
import 'package:balanced_foods/screens/Vendedor/modulo_pedidos/part_order.dart';
import 'package:flutter/material.dart';
import 'package:balanced_foods/models/customer.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
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
  late Customer _customer;
  @override
  void initState() {
    super.initState();
    _customer = widget.customer;
    Future.microtask(() async{
      final token = Provider.of<UsersProvider>(context, listen: false).token;
      final customersProvider = Provider.of<CustomersProvider>(context, listen: false);
      final ubigeosProvider = Provider.of<UbigeosProvider>(context, listen: false);
      final departmentsProvider = Provider.of<DepartmentsProvider>(context, listen: false);
      final ordersProvider = Provider.of<OrdersProvider2>(context, listen: false);
      final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
      final documentosProvider = Provider.of<OpcionCatalogoProvider>(context, listen: false);

      await customersProvider.fetchCustomers(token!);
      await ubigeosProvider.fetchUbigeos(token);
      await departmentsProvider.fetchDepartments(token);
      await documentosProvider.fetchOpcionesVenta(token);
      productsProvider.fetchProducts(token);
      await ordersProvider.fetchPedidosClienteCompletos(token, widget.customer.idCliente!).then((_) {
        productsProvider.loadPriceHistory(widget.customer.idCliente!, ordersProvider);
      });
      productsProvider.setCurrentCustomer(widget.customer.idCliente!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ubigeosProvider = Provider.of<UbigeosProvider>(context);
    final ubigeo = ubigeosProvider.ubigeos.firstWhere(
      (u) => u.id == _customer.idUbigeo,
      orElse: () => Ubigeo(id: 0, ubiDepartamento: '', ubiProvincia: '', ubiDistrito: ''),
    );

    String capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '';

    final direccion = _customer.direccion;
    final referencia = _customer.referencia;

    final tieneDireccion = direccion.trim().isNotEmpty;
    final tieneReferencia = referencia != null && referencia.trim().isNotEmpty;

    final mostrarTexto = tieneDireccion || tieneReferencia;
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
                        backgroundImage: _customer.fotoPerfil.isNotEmpty
                            ? NetworkImage('https://adysabackend.facturador.es/archivos/clientes/${Uri.encodeComponent(_customer.fotoPerfil)}')
                            : null,
                        backgroundColor: Colors.grey[300],
                        child: widget.customer.fotoPerfil.isEmpty
                            ? Icon(
                                Icons.person,
                                size: 100,
                                color: AppColors.gris,
                              )
                            : null,
                      ),
                      Text('${_customer.nombres} ${_customer.apellidos}', style: AppTextStyles.name),
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
                          final String phone = '+51${_customer.numero}';
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
                          _customer.numero.isEmpty
                          ? 'Sin número'
                          : _customer.numero.length == 9
                              ? '${_customer.numero.substring(0, 3)} ${_customer.numero.substring(3, 6)} ${_customer.numero.substring(6)}'
                              : _customer.numero,
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
                          final String phone = '51${_customer.numero}';
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
                          final String customerEmail = _customer.correo;
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
                        Text(
                          _customer.correo.isEmpty
                              ? 'Sin correo'
                              : _customer.correo,
                          style: AppTextStyles.base,
                        ),
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
                          final String customerEmail = _customer.correo;
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
                              '${_customer.direccion}, ${_customer.ubigeo}';

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
                          mostrarTexto
                            ? '${tieneDireccion ? direccion : ''}${tieneReferencia ? ' ($referencia)' : ''}'
                            : '',
                          style: AppTextStyles.base,
                          softWrap: true,
                        ),
                        Text(
                          ubigeo.id != 0
                            ? '${capitalize(ubigeo.ubiDepartamento)}, ${capitalize(ubigeo.ubiProvincia)}, ${capitalize(ubigeo.ubiDistrito)}'
                            : 'Ubicación no disponible',
                          style: AppTextStyles.base,
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
                              '${_customer.direccion}, ${_customer.referencia}, ${_customer.ubigeo}';

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
            SizedBox(height: 15),
            Column(
              children: [
                SizedBox(
                  width: 150,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () async {
                      final updatedCustomer = await showEditCustomerDialog(context, _customer);
                      if (updatedCustomer != null) {
                        setState(() {
                          _customer = updatedCustomer;
                        });
                      }
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
            Column(
              children: [
                RecordCard(
                  customer: _customer,
                  onCustomerUpdated: (updatedCustomer) {
                    setState(() {
                      _customer = updatedCustomer;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        
      ),
    );
  }
  
  Future<Customer?> showEditCustomerDialog(BuildContext context, Customer customer) async {
    final _formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: _customer.nombres);
    final lastNameController = TextEditingController(text: _customer.apellidos);
    final dniController = TextEditingController(text: _customer.nroDocumento);
    final phoneController = TextEditingController(text: _customer.numero);
    final emailController = TextEditingController(text: _customer.correo);
    final addressController = TextEditingController(text: _customer.direccion);
    final referenceController = TextEditingController(text: _customer.referencia);
    final rucController = TextEditingController(text: _customer.rucAfiliada);
    final razonSocialAfiliadaController = TextEditingController(text: _customer.razonSocialAfiliada);

    final token = Provider.of<UsersProvider>(context, listen: false).token;
    final customerProvider = Provider.of<CustomersProvider>(context, listen: false);
    final departmentsProvider = Provider.of<DepartmentsProvider>(context, listen: false);
    final provincesProvider = Provider.of<ProvincesProvider>(context, listen: false);
    final districtsProvider = Provider.of<DistrictsProvider>(context, listen: false);
    final ubigeosProvider = Provider.of<UbigeosProvider>(context, listen: false);

    final List<Ubigeo> ubigeos = ubigeosProvider.ubigeos;
    final Ubigeo? ubigeoCliente = ubigeos.firstWhere(
      (u) => u.id == widget.customer.idUbigeo, 
      orElse: () => Ubigeo(id: 0, ubiDepartamento: '', ubiProvincia: '', ubiDistrito: ''),
    );

    String? selectedDepartment = ubigeoCliente?.ubiDepartamento;
    String? selectedProvince = ubigeoCliente?.ubiProvincia;
    String? selectedDistrict = ubigeoCliente?.ubiDistrito;

    if (selectedDepartment != null) {
      await provincesProvider.fetchProvincesByDepartment(selectedDepartment, token!);
    }
    if (selectedProvince != null) {
      await districtsProvider.fetchDistrictsByProvince(selectedProvince, token!);
    }

    return showDialog<Customer>(
      context: context,
      builder: (context) {
        // Variables de estado local para el diálogo
        XFile? _selectedImage;
        String? _base64Image;
        final ImagePicker _picker = ImagePicker();        
        return StatefulBuilder(
          builder: (context, setState) {
            ValueNotifier<bool> _isPickingImage = ValueNotifier(false);
            // Selección de imagen
            Future<void> _pickImage() async {
              if (_isPickingImage.value) return;
              _isPickingImage.value = true;
              try {
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  final bytes = await File(image.path).readAsBytes();
                  final mimeType = lookupMimeType(image.path);
                  final base64Image = 'data:$mimeType;base64,${base64Encode(bytes)}';
                  setState(() {
                    _selectedImage = image;
                    _base64Image = base64Image;
                  });
                }
              } catch (e) {
                debugPrint('Error picking image: $e');
              } finally {
                _isPickingImage.value = false;
              }
            }

            Widget _buildCustomerImage(String? imageFileName) {
              final imageUrl = (imageFileName != null && imageFileName.isNotEmpty)
                  ? 'https://adysabackend.facturador.es/archivos/clientes/${Uri.encodeComponent(imageFileName)}'
                  : null;

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
                        : (imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(58),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.person, size: 80, color: Colors.grey),
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
                      _buildCustomerImage(_customer.fotoPerfil),
                      const SizedBox(height: 10),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Nombres',
                          labelStyle: AppTextStyles.editVars,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 1),
                        ),
                        style: AppTextStyles.base,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Apellidos',
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
                            return null;
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
                        controller: razonSocialAfiliadaController,
                        decoration: InputDecoration(
                          labelText: 'RUC Empresa',
                          labelStyle: AppTextStyles.editVars,
                        ),
                        style: AppTextStyles.base,
                      ),
                      TextField(
                        controller: rucController,
                        decoration: InputDecoration(
                          labelText: 'Razón social',
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
                        selectedValue: selectedDepartment ?? '',
                        options: departmentsProvider.departments.map((d) => d.department).toList(),
                        onChanged: (value) async{
                          setState(() {
                            selectedDepartment = value;
                            selectedProvince = null;
                            selectedDistrict = null;
                          });
                          await provincesProvider.fetchProvincesByDepartment(value!, token!);
                          districtsProvider.districts = [];
                          setState(() {});
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            // return 'Por favor, selecciona un departamento';
                            return null;
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
                                  selectedValue: selectedProvince ?? '',
                                  options: provincesProvider.provinces.map((p) => p.province).toList(),
                                  onChanged: (value) async {
                                    setState(() {
                                      selectedProvince = value;
                                      selectedDistrict = null;
                                    });
                                    await districtsProvider.fetchDistrictsByProvince(value!, token!);
                                    setState(() {});
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      // return 'Por favor, selecciona una provincia';
                                      return null;
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
                                  selectedValue: selectedDistrict ?? '',
                                  options: districtsProvider.districts.map((d) => d.district).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedDistrict = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      // return 'Por favor, selecciona un distrito';
                                      return null;
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final ubigeoNuevo = ubigeosProvider.ubigeos.firstWhere(
                        (u) =>
                          u.ubiDepartamento == selectedDepartment &&
                          u.ubiProvincia == selectedProvince &&
                          u.ubiDistrito == selectedDistrict,
                        orElse: () => Ubigeo(id: 0, ubiDepartamento: '', ubiProvincia: '', ubiDistrito: ''),
                      );
                      final updatedCustomer = customer.copyWith(
                        idListaPrecio: 1, // ajustar
                        estado: customer.estado, // ajustar
                        idTipoDocumento: 1, // preguntar
                        idPais: 1,
                        nombres: nameController.text,
                        apellidos: lastNameController.text,
                        nroDocumento: dniController.text,
                        fotoPerfil: _base64Image,
                        numero: phoneController.text,
                        correo: emailController.text,
                        direccion: addressController.text,
                        referencia: referenceController.text,
                        rucAfiliada: rucController.text,
                        razonSocialAfiliada: razonSocialAfiliadaController.text,
                        idUbigeo: ubigeoNuevo.id,
                        ubigeo: '${selectedDepartment ?? ''} ${selectedProvince ?? ''} ${selectedDistrict ?? ''}',
                      );

                      final updateBody = updatedCustomer.toUpdateJson();

                      // Ejecutas el update en el backend
                      await customerProvider.updateCustomer(updateBody, token!);
                      await customerProvider.fetchCustomers(token);

                      // Buscar el cliente por ID en la lista refrescada
                      final updated = customerProvider.customers.firstWhere(
                        (c) => c.idCliente == customer.idCliente,
                        orElse: () => customer,
                      );
                      Navigator.pop(context, updated);
                    }
                  },
                  child: Text('Guardar', style: AppTextStyles.btn),
                )
              ],
            );
          },
        );
      },
    );
  }
}

class RecordCard extends StatefulWidget {
  final Customer customer;
  final Function(Customer) onCustomerUpdated;
  
  const RecordCard({
    Key? key,
    required this.customer,
    required this.onCustomerUpdated,
  }) : super(key: key);

  @override
  State<RecordCard> createState() => _RecordCardState();
}

class _RecordCardState extends State<RecordCard> {
  // late Customer _customer;   ultimo comentado
  int _currentRecordPage = 1;
  final int _recordsPerPage = 20;
  int _currentInvoicePage = 1;
  final int _invoicesPerPage = 8;
  int _currentCreditPage = 1;
  final int _creditsPerPage = 10;

  // ultimo comentado
  // @override
  // void initState() {
  //   super.initState();
  //   _customer = widget.customer;
  // }

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

    // final provider = Provider.of<ProductsProvider>(context, listen: false);
    // provider.clearSelections();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 18, left: 18),
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
    return Consumer<OrdersProvider2>(
      builder: (context, ordersProvider, child) {
        final customerOrders = ordersProvider.pedidosClienteCompletos;

        if (ordersProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final totalRecords = customerOrders.length;
        final totalPages = (totalRecords / _recordsPerPage).ceil();
        final startIndex = (_currentRecordPage - 1) * _recordsPerPage;
        final endIndex = (_currentRecordPage * _recordsPerPage).clamp(0, totalRecords);
        final visibleRecords = customerOrders.sublist(startIndex, endIndex);

        return Card(
          color: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Encabezado
                Row(
                  children: [
                    Expanded(flex: 3, child: Text('Fecha', style: AppTextStyles.headerTable)),
                    Expanded(flex: 3, child: Text('Pedido', style: AppTextStyles.headerTable)),
                    Expanded(flex: 3, child: Text('Monto', style: AppTextStyles.headerTable)),
                    Expanded(flex: 3, child: Text('T. Pago', style: AppTextStyles.headerTable)),
                    Expanded(flex: 3, child: Text('Estado', style: AppTextStyles.headerTable)),
                  ],
                ),
                Divider(color: AppColors.lightGris, thickness: 1.0, height: 1),
                const SizedBox(height: 8),

                // Sin registros
                if (visibleRecords.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('No hay pedidos registrados', style: AppTextStyles.bodyTable),
                  )
                else
                  Column(
                    children: [
                      ListView.builder(
                        itemCount: visibleRecords.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final order = visibleRecords[index];
                          final pagado = order.total! - order.totalPagado!;
                          final estadoPago = pagado == 0 ? 'Pagado' : 'Pendiente';

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    order.fechaEmision != null
                                        ? DateFormat('dd/MM/yy').format(order.fechaEmision!)
                                        : 'Sin fecha',
                                    style: AppTextStyles.bodyTable,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    '${order.idOrder ?? "-"}-2025',
                                    style: AppTextStyles.bodyTable,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    '${order.total!.toStringAsFixed(2)}',
                                    style: AppTextStyles.bodyTable,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    order.paymentMethod ?? '-',
                                    style: AppTextStyles.bodyTable,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    estadoPago,
                                    style: AppTextStyles.bodyTable,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // Paginación
                      if (totalPages > 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              iconSize: 15,
                              onPressed: _currentRecordPage > 1
                                  ? () => setState(() => _currentRecordPage--)
                                  : null,
                            ),
                            Text('Página $_currentRecordPage de $totalPages', style: AppTextStyles.headerTable),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward),
                              iconSize: 15,
                              onPressed: _currentRecordPage < totalPages
                                  ? () => setState(() => _currentRecordPage++)
                                  : null,
                            ),
                          ],
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

  Widget _ordersDetail() {
    List<OpcionCatalogo> documentosVenta = [];
    List<OpcionCatalogo> tiposPago = [];
    final documentsProvider = Provider.of<OpcionCatalogoProvider>(context);
    documentosVenta = documentsProvider.documentosVenta;
    tiposPago = documentsProvider.tipoPago;
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: SizedBox(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              receiptType(tiposComprobante: documentosVenta, key: _receiptKey),
              const SizedBox(height: 20),
              partOrder(idCustomer: widget.customer.idCliente!),
              const SizedBox(height: 15),
              SearchProduct(idCustomer: widget.customer.idCliente!),
              const SizedBox(height: 20),
              ResumeProduct(selectedProducts: Provider.of<ProductsProvider>(context).selectedProducts,),
              const SizedBox(height: 10),
              paymentMethod(tiposPago: tiposPago, key: _paymentKey),
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
    return Consumer<OrdersProvider2>(
      builder: (context, ordersProvider, child) {
        return Consumer<CustomersProvider>(
          builder: (context, customersProvider, child) {
            final customerOrders = ordersProvider.pedidosClienteCompletos
            .where((order) => order.totalPagado != 0)
            .toList();


            final totalInvoices = customerOrders.length;
            final totalPages = (totalInvoices / _invoicesPerPage).ceil();

            final startIndex = (_currentInvoicePage - 1) * _invoicesPerPage;
            final endIndex = (_currentInvoicePage * _invoicesPerPage).clamp(0, totalInvoices);
            final visibleInvoices = customerOrders.sublist(startIndex, endIndex);

            if (ordersProvider.isLoading || customersProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Card(
              color: Colors.transparent,
              elevation: 0,
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('RELACIÓN DE FACTURAS', style: AppTextStyles.cardTitle),
                    Divider(color: AppColors.lightGris, thickness: 1.0, height: 25),

                    if (visibleInvoices.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text('No hay facturas registradas', style: AppTextStyles.bodyTable),
                      )
                    else
                      Column(
                        children: [
                          ListView.builder(
                            itemCount: visibleInvoices.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final order = visibleInvoices[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  children: [
                                    Text('Pedido ${order.idOrder ?? "-"}-2025', style: AppTextStyles.base),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        final facturaProvider = Provider.of<FacturasProvider>(context, listen: false);
                                        final token = Provider.of<UsersProvider>(context, listen: false).token;
                                        facturaProvider.generarTicket(token!, order.idOrder!);
                                      },
                                      child: Icon(Icons.attach_file, color: Colors.black, size: 20),
                                    ),
                                    const SizedBox(width: 20),
                                    IconButton(
                                      icon: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Image.asset('assets/images/whatsapp.png', color: Colors.black),
                                      ),
                                      onPressed: () async {
                                        final customer = customersProvider.customers.firstWhere(
                                          (c) => c.idCliente == order.idCustomer,
                                        );

                                        final mensaje = Uri.encodeComponent(
                                            'Hola ${customer.nombres}, te comparto la factura de tu pedido. Gracias por su compra.');
                                        final numeroSinPrefijo = customer.numero.replaceAll('+', '').replaceAll(' ', '');
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

                          const SizedBox(height: 12),

                          // Paginación
                          if (totalPages > 1)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  iconSize: 15,
                                  onPressed: _currentInvoicePage > 1
                                      ? () => setState(() => _currentInvoicePage--)
                                      : null,
                                ),
                                Text('Página $_currentInvoicePage de $totalPages', style: AppTextStyles.headerTable),
                                IconButton(
                                  icon: const Icon(Icons.arrow_forward),
                                  iconSize: 15,
                                  onPressed: _currentInvoicePage < totalPages
                                      ? () => setState(() => _currentInvoicePage++)
                                      : null,
                                ),
                              ],
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }

  Widget _creditsDetail() {
    return Consumer<OrdersProvider2>(
      builder: (context, ordersProvider, child) {
        final customerOrders = ordersProvider.pedidosClienteCompletos
            .where((order) => order.paymentMethod == 'Credito')
            .toList();

        final totalCredits = customerOrders.length;
        final totalPages = (totalCredits / _creditsPerPage).ceil();

        final startIndex = (_currentCreditPage - 1) * _creditsPerPage;
        final endIndex = (_currentCreditPage * _creditsPerPage).clamp(0, totalCredits);
        final visibleCredits = customerOrders.sublist(startIndex, endIndex);

        if (ordersProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Card(
          color: Colors.transparent,
          elevation: 0,
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

              if (visibleCredits.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text('No hay créditos registrados', style: AppTextStyles.bodyTable),
                )
              else
                Column(
                  children: [
                    ListView.builder(
                      itemCount: visibleCredits.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final order = visibleCredits[index];
                        final pagado = order.total! - order.totalPagado!;
                        final estadoPago = pagado == 0 ? 'Pagado' : 'Pendiente';

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                order.fechaEmision != null
                                    ? DateFormat('dd/MM/yy').format(order.fechaEmision!)
                                    : '--/--/--',
                                style: AppTextStyles.bodyTable,
                              ),
                              Text(
                                'Pedido ${order.idOrder ?? "-"}-2025',
                                style: AppTextStyles.bodyTable,
                              ),
                              Text(
                                order.cuotas != null && order.cuotas!.isNotEmpty && order.cuotas!.first.fecha != null
                                    ? DateFormat('dd/MM/yy').format(order.cuotas!.first.fecha!)
                                    : '--/--/--',
                                style: AppTextStyles.bodyTable,
                              ),
                              Text(
                                'S/. ${order.total!.toStringAsFixed(2)}',
                                style: AppTextStyles.bodyTable,
                              ),
                              estadoPago == 'Pagado'
                                  ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                                  : const Icon(Icons.cancel, color: Colors.red, size: 20),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    // Paginación
                    if (totalPages > 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            iconSize: 15,
                            onPressed: _currentCreditPage > 1
                                ? () => setState(() => _currentCreditPage--)
                                : null,
                          ),
                          Text('Página $_currentCreditPage de $totalPages', style: AppTextStyles.headerTable),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            iconSize: 15,
                            onPressed: _currentCreditPage < totalPages
                                ? () => setState(() => _currentCreditPage++)
                                : null,
                          ),
                        ],
                      ),
                  ],
                ),
            ],
          ),
        );
      }
    );
  }

  void _registerOrder() {
    final idCustomer = widget.customer.idCliente;
    final products = Provider.of<ProductsProvider>(context, listen: false);
    final selectedProducts = products.selectedProducts;
    final paymentMethod = _paymentKey.currentState?.selectedPaymentId;
    final receiptType = _receiptKey.currentState?.selectedId;

    // Validar tipo de recibo
    if (receiptType == null || receiptType == 0) {
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

    if (paymentMethod == null || paymentMethod == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selecciona un método de pago")),
      );
      return;
    }

    registerOrder(
      context: context,
      idCustomer: idCustomer,
      receiptKey: _receiptKey,
      observationsKey: _observationsKey,
      paymentKey: _paymentKey,
      resetForm: _resetForm,
    );

    if (context.mounted) {
      Navigator.pop(context);
    }
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
  static final btn = base.copyWith(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.orange);
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


