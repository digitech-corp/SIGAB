import 'package:balanced_foods/models/customer.dart';
import 'package:balanced_foods/models/ubigeo.dart';
import 'package:balanced_foods/providers/customers_provider.dart';
import 'package:balanced_foods/providers/departments_provider.dart';
import 'package:balanced_foods/providers/districts_provider.dart';
import 'package:balanced_foods/providers/provinces_provider.dart';
import 'package:balanced_foods/providers/ubigeos_provider.dart';
import 'package:balanced_foods/providers/users_provider.dart';
import 'package:balanced_foods/screens/Vendedor/modulo_clientes/customer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:mime/mime.dart';

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
  final _customerImage = TextEditingController();
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
  String? _selectedProvince;
  String? _selectedDistrict;

  @override
  void dispose() {
    _customerName.dispose();
    _customerLastName.dispose();
    _dni.dispose();
    _customerImage.dispose();
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
            backgroundColor: const Color(0xFFFF6600),
            title: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
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
                customerImage: _customerImage,
                customerPhone: _customerPhone,
                customerEmail: _customerEmail,
                customerAddress: _customerAddress,
                customerReference: _customerReference,
                companyRUC: _companyRUC,
                companyName: _companyName,
                companyAddress: _companyAddress,
                companyWeb: _companyWeb,
                idCompany: _idCompany,
                selectedDepartment: _selectedDepartment,
                selectedProvince: _selectedProvince,
                selectedDistrict: _selectedDistrict,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewCustomerForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController customerName;
  final TextEditingController customerLastName;
  final TextEditingController dni;
  final TextEditingController customerImage;
  final TextEditingController customerPhone;
  final TextEditingController customerEmail;
  final TextEditingController customerAddress;
  final TextEditingController customerReference;
  final TextEditingController companyRUC;
  final TextEditingController companyName;
  final TextEditingController companyAddress;
  final TextEditingController companyWeb;
  final TextEditingController idCompany;
  final String? selectedDepartment;
  final String? selectedProvince;
  final String? selectedDistrict;

  NewCustomerForm({
    super.key,
    required this.formKey,
    required this.customerName,
    required this.customerLastName,
    required this.dni,
    required this.customerImage,
    required this.customerPhone,
    required this.customerEmail,
    required this.customerAddress,
    required this.customerReference,
    required this.companyRUC,
    required this.companyName,
    required this.companyAddress,
    required this.companyWeb,
    required this.idCompany,
    required this.selectedDepartment,
    required this.selectedProvince,
    required this.selectedDistrict,
  });

  @override
  State<NewCustomerForm> createState() => _NewCustomerFormState();
}

class _NewCustomerFormState extends State<NewCustomerForm> {
  String? selectedDepartment;
  String? selectedProvince;
  String? selectedDistrict;
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  String? _base64Image;

  Future<void> _pickImage() async {
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
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: _selectedImage != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(_selectedImage!.path),
                fit: BoxFit.cover,
                width: 80,
                height: 80,
              ),
            )
          : Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.add_a_photo, color: Colors.grey),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    selectedDepartment = widget.selectedDepartment;
    selectedProvince = widget.selectedProvince;
    selectedDistrict = widget.selectedDistrict;
  }

  Customer? _buscarEmpresaPorRuc(String ruc) {
    final customers = Provider.of<CustomersProvider>(context, listen: false).customers;
    try {
      return customers.firstWhere((c) => c.rucAfiliada == ruc);
    } catch (e) {
      return null;
    }
  }

  void _buscarYCompletarEmpresaPorRuc(String ruc) {
    final empresa = _buscarEmpresaPorRuc(ruc);

    if (empresa != null) {
      setState(() {
        widget.companyName.text = empresa.razonSocialAfiliada;
        widget.companyAddress.text = empresa.direccionAfiliada;
        // widget.companyWeb.text = empresa.sitioWeb ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<UsersProvider>(context, listen: false).token;
    final departmentsProvider = Provider.of<DepartmentsProvider>(context);
    final provincesProvider = Provider.of<ProvincesProvider>(context);
    final districtsProvider = Provider.of<DistrictsProvider>(context);
    final customerProvider = Provider.of<CustomersProvider>(context, listen: false);
    final ubigeosProvider = Provider.of<UbigeosProvider>(context, listen: false);

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: widget.customerName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa el nombre del cliente';
                        }
                        return null;
                      },
                      hintText: 'Nombres',
                      hintStyle: AppTextStyles.base,
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: widget.customerLastName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa el apellido del cliente';
                        }
                        return null;
                      },
                      hintText: 'Apellidos',
                      hintStyle: AppTextStyles.base,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 80,
                height: 80,
                child: _buildImagePicker(),
              ),
            ],
          ),
          const SizedBox(height: 07),
          _buildTextField(
            controller: widget.dni,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa el número de DNI';
              }
              if (value.length != 8) {
                return 'El DNI debe tener exactamente 8 dígitos';
              }
              return null;
            },
            hintText: 'DNI',
            hintStyle: AppTextStyles.base,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(8),
            ],
          ),
          const SizedBox(height: 7),
          _buildTextField(
            controller: widget.customerPhone,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa el número de celular';
              }
              if (value.length != 9) {
                return 'El número de celular debe tener exactamente 9 dígitos';
              }
              if (!value.startsWith('9')) {
                return 'El número de celular debe comenzar con 9';
              }
              return null;
            },
            hintText: 'Celular',
            hintStyle: AppTextStyles.base,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(9),
            ],
          ),
          const SizedBox(height: 07),
          _buildTextField(
            controller: widget.customerEmail,
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
            hintText: 'Correo Electrónico',
            hintStyle: AppTextStyles.base
          ),
          const SizedBox(height: 07),
          _buildTextField(
            controller: widget.customerAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa la dirección';
              }
              return null;
            },
            hintText: 'Dirección...',
            hintStyle: AppTextStyles.base
          ),
          const SizedBox(height: 07),
          _buildTextField(
            controller: widget.customerReference,
            validator: (value) {
              // if (value == null || value.isEmpty) {
              //   return 'Por favor, ingresa una referencia';
              // }
              return null;
            },
            hintText: 'Referencia',
            hintStyle: AppTextStyles.base
          ),
          const SizedBox(height: 07),
          BuildSelect(
            selectedValue: selectedDepartment,
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
                return 'Por favor, selecciona un departamento';
              }
              return null;
            },
            hintText: 'Departamento',
          ),
          const SizedBox(height: 07),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: BuildSelect(
                  selectedValue: selectedProvince,
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
                      return 'Por favor, selecciona una provincia';
                    }
                    return null;
                  },
                  hintText: 'Provincia',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BuildSelect(
                  selectedValue: selectedDistrict,
                  options: districtsProvider.districts.map((d) => d.district).toList(),
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
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Datos de la Empresa', style: AppTextStyles.subtitle),
          const SizedBox(height: 07),
          _buildTextField(
            controller: widget.companyRUC,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Por favor, ingresa el RUC';
              if (value.length != 11) return 'El RUC debe tener exactamente 11 dígitos';
              return null;
            },
            hintText: 'RUC',
            hintStyle: AppTextStyles.base,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            onChanged: (ruc) {
              if (ruc.length == 11) {
                _buscarYCompletarEmpresaPorRuc(ruc);
              } else {
                setState(() {
                  widget.companyName.text = '';
                  widget.companyAddress.text = '';
                  widget.companyWeb.text = '';
                });
              }
            },
          ),
          const SizedBox(height: 07),
          _buildTextField(
            controller: widget.companyName,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa la razón social';
              }
              return null;
            },
            hintText: 'Razón Social',
            hintStyle: AppTextStyles.base
          ),
          const SizedBox(height: 07),
          _buildTextField(
            controller: widget.companyAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa la dirección fiscal';
              }
              return null;
            },
            hintText: 'Dirección Fiscal',
            hintStyle: AppTextStyles.base
          ),
          // const SizedBox(height: 07),
          // _buildTextField(
          //   controller: widget.companyWeb,
          //   validator: (value) {
          //     return null;
          //   },
          //   hintText: 'Sitio Web',
          //   hintStyle: AppTextStyles.base
          // ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 282,
              height: 37,
              child: ElevatedButton(
                onPressed: () async {
                  if (widget.formKey.currentState!.validate()) {
                    final dni = widget.dni.text.trim();
                    final phone = widget.customerPhone.text.trim();
                    final email = widget.customerEmail.text.trim();

                    // Accede a la lista local de clientes registrados en el provider
                    final customers = Provider.of<CustomersProvider>(context, listen: false).customers;
                    String? errorMsg;

                    // Validación de duplicados
                    if (customers.any((c) => c.nroDocumento == dni)) {
                      errorMsg = "El DNI ya está registrado";
                    } else if (customers.any((c) => c.numero == phone)) {
                      errorMsg = "El número de celular ya está registrado";
                    } else if (customers.any((c) => c.correo.toLowerCase() == email.toLowerCase())) {
                      errorMsg = "El correo electrónico ya está registrado";
                    }

                    if (errorMsg != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(errorMsg)),
                      );
                      return; // Sale sin registrar si se encontró duplicado
                    }

                    try {
                      final ubigeoId = ubigeosProvider.ubigeos.firstWhere(
                        (u) =>
                            u.ubiDepartamento == selectedDepartment &&
                            u.ubiProvincia == selectedProvince &&
                            u.ubiDistrito == selectedDistrict,
                        orElse: () => Ubigeo(id: 0, ubiDepartamento: '', ubiProvincia: '', ubiDistrito: ''),
                      );

                      String fechaCreada = DateTime.now().toIso8601String();

                      // Crear Customer
                      final newCustomer = Customer(
                        idListaPrecio: 1,
                        idTipoCliente: 0,
                        estado: 1, // preguntar
                        fechaCreado: fechaCreada,
                        fotoPerfil: _base64Image ?? '',
                        nroDocumento: widget.dni.text,
                        idTipoDocumento: 1, // preguntar
                        nombres: widget.customerName.text,
                        apellidos: widget.customerLastName.text,
                        fechaNacimiento: "",
                        correo: widget.customerEmail.text,
                        numero: widget.customerPhone.text,
                        idPais: 1,
                        idUbigeo: ubigeoId.id,
                        direccion: widget.customerAddress.text,
                        referencia: widget.customerReference.text,
                        rucAfiliada: widget.companyRUC.text,
                        razonSocialAfiliada: widget.companyName.text,
                        direccionAfiliada: widget.companyAddress.text,
                      );

                      await customerProvider.registerCustomer(newCustomer, token!);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Se ha añadido exitosamente")),
                      );
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerScreen(showSuccess: true),
                          ),
                        );
                      });
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool obscureText = false,
    String? hintText,
    TextStyle? hintStyle,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: AppTextStyles.selectStyle,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:
            hintStyle ??
            AppTextStyles.base,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 5.0),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightGris, width: 0.5),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightGris, width: 0.5),
        ),
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }
}

class BuildSelect extends StatelessWidget {
  final String? selectedValue;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final String? Function(String?) validator;
  final String? hintText;
  const BuildSelect({
    required this.selectedValue,
    required this.options,
    required this.onChanged,
    required this.validator,
    required this.hintText,
    super.key,
  });

  String capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}' : '';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: selectedValue,
      onChanged: onChanged,
      style: AppTextStyles.selectStyle,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightGris, width: 0.5),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightGris, width: 0.5),
        ),
      ),
      hint: Text(
        hintText ?? '',
        style: AppTextStyles.base,
      ),
      validator: validator,
      items:
          options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                capitalize(value),
                style: AppTextStyles.selectStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
            );
          }).toList(),
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
}

class AppColors {
  static const orange = Color(0xFFFF6600);
  static const gris = Color(0xFF333333);
  static const lightGris = Color(0xFFBDBDBD);
}