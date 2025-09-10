import 'package:balanced_foods/models/customer.dart';
import 'package:balanced_foods/models/tipoCliente.dart';
import 'package:balanced_foods/models/tipoDocumento.dart';
import 'package:balanced_foods/models/ubigeo.dart';
import 'package:balanced_foods/providers/customers_provider.dart';
import 'package:balanced_foods/providers/departments_provider.dart';
import 'package:balanced_foods/providers/tipos_cliente_provider.dart';
import 'package:balanced_foods/providers/tipos_documento_provider.dart';
import 'package:balanced_foods/providers/ubigeos_provider.dart';
import 'package:balanced_foods/providers/users_provider.dart';
import 'package:balanced_foods/screens/Vendedor/modulo_clientes/customer_screen.dart';
import 'package:balanced_foods/screens/Vendedor/modulo_clientes/form_customer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NewCustomerScreen extends StatefulWidget {
  final bool showSuccess;

  const NewCustomerScreen({super.key, this.showSuccess = false});

  @override
  State<NewCustomerScreen> createState() => _NewCustomerScreenState();
}

class _NewCustomerScreenState extends State<NewCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerName = TextEditingController();
  final _customerLastName = TextEditingController();
  final _dni = TextEditingController();
  final _customerPhone = TextEditingController();
  final _customerEmail = TextEditingController();
  final _customerAddress = TextEditingController();
  final _customerReference = TextEditingController();
  final _companyRUC = TextEditingController();
  final _companyName = TextEditingController();
  final _companyAddress = TextEditingController();
  final _companyWeb = TextEditingController();
  final _idCompany = TextEditingController();
  String? _selectedDepartment;
  String? _selectedTipoCliente;
  String? _selectedTipoDocumento;
  String? _selectedProvince;
  String? _selectedDistrict;
  String? _base64Image;

  @override
  void dispose() {
    _customerName.dispose();
    _customerLastName.dispose();
    _dni.dispose();
    _customerPhone.dispose();
    _customerEmail.dispose();
    _customerAddress.dispose();
    _customerReference.dispose();
    _companyRUC.dispose();
    _companyName.dispose();
    _companyAddress.dispose();
    _companyWeb.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final userProvider = Provider.of<UsersProvider>(context, listen: false);
      final token = userProvider.token;
      final ubigeosProvider = Provider.of<UbigeosProvider>(context, listen: false);
      await ubigeosProvider.fetchUbigeos(token!);
      final departmentsProvider = Provider.of<DepartmentsProvider>(context, listen: false);
      await departmentsProvider.fetchDepartments(token);
      final tipoClienteProvider = Provider.of<TipoClienteProvider>(context, listen: false);
      await tipoClienteProvider.fetchTipoCliente(token);
      final tipoDocumentoProvider = Provider.of<TipoDocumentoProvider>(context, listen: false);
      await tipoDocumentoProvider.fetchTipoDocumento(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tipoClientesProvider = Provider.of<TipoClienteProvider>(context);
    final tipoDocumentoProvider = Provider.of<TipoDocumentoProvider>(context);
    final token = Provider.of<UsersProvider>(context, listen: false).token;
    final ubigeosProvider = Provider.of<UbigeosProvider>(context);
    final customerProvider = Provider.of<CustomersProvider>(context, listen: false);
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
            backgroundColor: const Color(0xFFFF6600),
            title: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () async {
                    final confirmExit = await showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        title: Text('Descartar cambios', style: AppTextStyles.subtitleBack),
                        content: Text('Se descartarán los cambios. ¿Estás seguro?', style: AppTextStyles.subtitle),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('NO', style: AppTextStyles.btn),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text('SI', style: AppTextStyles.btn),
                          ),
                        ],
                      ),
                    );
                    if (confirmExit == true) {
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                ),
                const SizedBox(width: 1),
                Text('Registrar Nuevo Cliente', style: AppTextStyles.title),
              ],
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Identificación Personal', style: AppTextStyles.subtitle),
              const SizedBox(height: 07),
              NewCustomerForm(
                formKey: _formKey,
                customerName: _customerName,
                customerLastName: _customerLastName,
                dni: _dni,
                onImageChanged: (value) {
                  _base64Image = value;
                },
                customerPhone: _customerPhone,
                customerEmail: _customerEmail,
                customerAddress: _customerAddress,
                customerReference: _customerReference,
                companyRUC: _companyRUC,
                companyName: _companyName,
                companyAddress: _companyAddress,
                companyWeb: _companyWeb,
                idCompany: _idCompany,
                selectedTipoCliente: _selectedTipoCliente,
                onSelectedTipoCliente: (value) {
                  setState(() {
                    _selectedTipoCliente = value;
                  });
                },
                selectedTipoDocumento: _selectedTipoDocumento,
                onSelectedTipoDocumento: (value) {
                  setState(() {
                    _selectedTipoDocumento = value;
                  });
                },
                selectedDepartment: _selectedDepartment,
                onSelectedDepartment: (value) {
                  setState(() {
                    _selectedDepartment = value;
                  });
                },
                selectedProvince: _selectedProvince,
                onSelectedProvince: (value) {
                  setState(() {
                    _selectedProvince = value;
                  });
                },
                selectedDistrict: _selectedDistrict,
                onSelectedDistrict: (value) {
                  setState(() {
                    _selectedDistrict = value;
                  });
                },
                enableImagePicker: true,
              ),
              Center(
                child: SizedBox(
                  width: 282,
                  height: 37,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final dni = _dni.text.trim();
                        final phone = _customerPhone.text.trim();
                        final email = _customerEmail.text.trim();

                        final customers = Provider.of<CustomersProvider>(context, listen: false).customers;
                        String? errorMsg;

                        if (customers.any((c) => c.nroDocumento == dni)) {
                          errorMsg = "El DNI ya está registrado";
                        } else if (customers.any((c) => c.numero == phone)) {
                          errorMsg = "El número de celular ya está registrado";
                        } else if (
                          email != 'notiene@gmail.com' && 
                          email != '' && 
                          customers.any((c) => c.correo == email)
                        ) {
                            errorMsg = "El correo electrónico ya está registrado";
                        }
                        if (errorMsg != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(errorMsg)),
                          );
                          return;
                        }

                        try {
                          final ubigeoId = ubigeosProvider.ubigeos.firstWhere(
                            (u) =>
                                u.ubiDepartamento == _selectedDepartment &&
                                u.ubiProvincia == _selectedProvince &&
                                u.ubiDistrito == _selectedDistrict,
                            orElse: () => Ubigeo(id: 0, ubiDepartamento: '', ubiProvincia: '', ubiDistrito: ''),
                          );

                          final tipoDocumento = tipoDocumentoProvider.tiposDocumento.firstWhere(
                            (t) => t.nombre == _selectedTipoDocumento,
                            orElse: () => TipoDocumento(nombre: ''),
                          );

                          final tipoCliente = tipoClientesProvider.tiposCliente.firstWhere(
                            (t) => t.nombre == _selectedTipoCliente,
                            orElse: () => TipoCliente(nombre: ''),
                          );

                          String fechaCreada = DateTime.now().toIso8601String();

                          final newCustomer = Customer(
                            idListaPrecio: 1,
                            idTipoCliente: tipoCliente.id,
                            estado: 1,
                            fechaCreado: fechaCreada,
                            fotoPerfil: _base64Image,
                            nroDocumento: _dni.text,
                            idTipoDocumento: tipoDocumento.id,
                            nombres: _customerName.text,
                            apellidos: _customerLastName.text,
                            fechaNacimiento: "",
                            correo: _customerEmail.text,
                            numero: _customerPhone.text,
                            idPais: 1,
                            idUbigeo: ubigeoId.id,
                            direccion: _customerAddress.text,
                            referencia: _customerReference.text,
                            rucAfiliada: _companyRUC.text,
                            razonSocialAfiliada:_companyName.text,
                            direccionAfiliada: _companyAddress.text,
                          );

                          await customerProvider.registerCustomer(newCustomer, token!);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Se ha añadido exitosamente")),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomerScreen(showSuccess: true),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error al registrar: ${e.toString()}")),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: AppColors.orange, width: 1),
                      ),
                    ),
                    child: Text('Añadir Contacto', style: AppTextStyles.btn),
                  ),
                ),
              ),
              const SizedBox(height: 40),
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
    fontSize: 16,
    color: AppColors.lightGris
  );
  static final title = base.copyWith(fontWeight: FontWeight.w600, color: AppColors.gris);
  static final subtitle = base.copyWith(color: Colors.black);
  static final name = base.copyWith(fontSize: 20);
  static final btn = base.copyWith(fontSize: 14, color: AppColors.orange, fontWeight: FontWeight.w500);
  static final selectStyle = base.copyWith(fontSize: 13, color: AppColors.gris);
  static final subtitlebtn = base.copyWith(color: AppColors.gris, fontSize: 16, fontWeight: FontWeight.w500);
  static final subtitleBack = base.copyWith(color: AppColors.gris, fontWeight: FontWeight.w400);
}

class AppColors {
  static const orange = Color(0xFFFF6600);
  static const gris = Color(0xFF333333);
  static const lightGris = Color(0xFFBDBDBD);
}