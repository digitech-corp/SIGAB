import 'package:balanced_foods/models/company.dart';
import 'package:balanced_foods/models/customer.dart';
import 'package:balanced_foods/models/province.dart';
import 'package:balanced_foods/providers/companies_provider.dart';
import 'package:balanced_foods/providers/customers_provider.dart';
import 'package:balanced_foods/providers/departments_provider.dart';
import 'package:balanced_foods/providers/districts_provider.dart';
import 'package:balanced_foods/providers/provinces_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class NewCustomerScreen extends StatefulWidget {
  final bool showSuccess;

  const NewCustomerScreen({super.key, this.showSuccess = false});

  @override
  State<NewCustomerScreen> createState() => _NewCustomerScreenState();
}

class _NewCustomerScreenState extends State<NewCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerName = TextEditingController();
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
    Future.microtask(() {
      Provider.of<DepartmentsProvider>(context, listen: false).fetchDepartments();
      Provider.of<ProvincesProvider>(context, listen: false).fetchProvinces();
      Provider.of<DistrictsProvider>(context, listen: false).fetchDistricts();
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
      final base64Image = base64Encode(bytes);
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

  @override
  Widget build(BuildContext context) {
    final departmentsProvider = Provider.of<DepartmentsProvider>(context);
    final provincesProvider = Provider.of<ProvincesProvider>(context);
    final districtsProvider = Provider.of<DistrictsProvider>(context);
    //Nuevo
    final companyProvider = Provider.of<CompaniesProvider>(context, listen: false);
    final customerProvider = Provider.of<CustomersProvider>(context, listen: false);

    final filteredProvinces =
        selectedDepartment == null
            ? []
            : provincesProvider.getProvincesByDepartment(
              departmentsProvider.departments
                  .firstWhere((d) => d.department == selectedDepartment)
                  .idDepartment,
            );
    final filteredDistricts =
        selectedProvince == null
            ? []
            : districtsProvider.districts.where((d) {
              final province = filteredProvinces.firstWhere(
                (p) => p.province == selectedProvince,
                orElse:
                    () =>
                        Province(idProvince: 0, province: '', idDepartment: 0),
              );
              return d.idProvince == province.idProvince;
            }).toList();
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildTextField(
                  controller: widget.customerName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa un nombre de usuario';
                    }
                    return null;
                  },
                  hintText: 'p. ej. Alfredo Fiestas',
                  hintStyle: AppTextStyles.base
                ),
              ),
              _buildImagePicker()
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
              return null;
            },
            hintText: 'DNI',
            hintStyle: AppTextStyles.base,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(8),
            ],
          ),
          const SizedBox(height: 07),
          _buildTextField(
            controller: widget.customerPhone,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa el número de celular';
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
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa una referencia';
              }
              return null;
            },
            hintText: 'Referencia',
            hintStyle: AppTextStyles.base
          ),
          const SizedBox(height: 07),
          _buildSelect(
            selectedValue: selectedDepartment,
            options:
                departmentsProvider.departments
                    .map((d) => d.department)
                    .toList(),
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
          const SizedBox(height: 07),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildSelect(
                  selectedValue: selectedProvince,
                  options:
                      filteredProvinces
                          .map((p) => p.province.toString())
                          .toList(),
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
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSelect(
                  selectedValue: selectedDistrict,
                  options:
                      filteredDistricts
                          .map((d) => d.district.toString())
                          .toList(),
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
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa el RUC';
              }
              return null;
            },
            hintText: 'RUC',
            hintStyle: AppTextStyles.base,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
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
          const SizedBox(height: 07),
          _buildTextField(
            controller: widget.companyWeb,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa el sitio web';
              }
              return null;
            },
            hintText: 'Sitio Web',
            hintStyle: AppTextStyles.base
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 282,
              height: 37,
              child: ElevatedButton(
                onPressed: () async {
                  if (widget.formKey.currentState!.validate()) {
                    try {
                      //Crear company
                      final newCompany = Company(
                        companyName: widget.companyName.text,
                        companyRUC: widget.companyRUC.text,
                        companyAddress: widget.companyAddress.text,
                        companyWeb: widget.companyWeb.text,
                      );

                      // Enviar Company al backend y obtener idCompany generado
                      final int companyId = await companyProvider.createCompany(newCompany);
                      int _getDepartmentIdByName(String name) {
                        return departmentsProvider.departments
                            .firstWhere((d) => d.department == name)
                            .idDepartment;
                      }

                      int _getProvinceIdByName(String name) {
                        return filteredProvinces
                            .firstWhere((p) => p.province == name)
                            .idProvince;
                      }

                      int _getDistrictIdByName(String name) {
                        return filteredDistricts
                            .firstWhere((d) => d.district == name)
                            .idDistrict;
                      }
                      
                      // Crear Customer
                      final newCustomer = Customer(
                        customerName: widget.customerName.text,
                        dni: widget.dni.text,
                        customerImage: _base64Image ?? '',
                        customerPhone: widget.customerPhone.text,
                        customerEmail: widget.customerEmail.text,
                        customerAddress: widget.customerAddress.text,
                        customerReference: widget.customerReference.text,
                        idCompany: companyId,
                        idDepartment: _getDepartmentIdByName(selectedDepartment!),
                        idProvince: _getProvinceIdByName(selectedProvince!),
                        idDistrict: _getDistrictIdByName(selectedDistrict!),
                      );

                      await customerProvider.registerCustomer(newCustomer);
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Se ha añadido exitosamente")),
                      );

                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    NewCustomerScreen(showSuccess: true),
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
    );
  }

  Widget _buildSelect({
    required String? selectedValue,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    required String? Function(String?) validator,
    String? hintText,
  }) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      onChanged: onChanged,
      style: AppTextStyles.selectStyle,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 5.0),
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
                value,
                style: AppTextStyles.selectStyle,
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
  static final selectStyle = base.copyWith(color: AppColors.gris);
}

class AppColors {
  static const orange = Color(0xFFFF6600);
  static const gris = Color(0xFF333333);
  static const lightGris = Color(0xFFBDBDBD);
}