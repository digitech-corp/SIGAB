import 'dart:convert';
import 'dart:io';
import 'package:balanced_foods/models/tipoDocumento.dart';
import 'package:balanced_foods/models/ubigeo.dart';
import 'package:balanced_foods/providers/departments_provider.dart';
import 'package:balanced_foods/providers/districts_provider.dart';
import 'package:balanced_foods/providers/provinces_provider.dart';
import 'package:balanced_foods/providers/tipos_cliente_provider.dart';
import 'package:balanced_foods/providers/tipos_documento_provider.dart';
import 'package:balanced_foods/providers/ubigeos_provider.dart';
import 'package:balanced_foods/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

class NewCustomerForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController customerName;
  final TextEditingController? customerLastName;
  final TextEditingController dni;
  final ValueChanged<String?> onImageChanged;
  final TextEditingController? customerPhone;
  final TextEditingController? customerEmail;
  final TextEditingController customerAddress;
  final TextEditingController? customerReference;
  final TextEditingController? companyRUC;
  final TextEditingController? companyName;
  final TextEditingController? companyAddress;
  final TextEditingController? companyWeb;
  final TextEditingController? idCompany;
  final String? selectedTipoDocumento;
  final ValueChanged<String?> onSelectedTipoDocumento;
  final String? selectedTipoCliente;
  final ValueChanged<String?> onSelectedTipoCliente;
  final String? selectedDepartment;
  final String? selectedProvince;
  final String? selectedDistrict;
  final ValueChanged<String?>? onSelectedDepartment;
  final ValueChanged<String?>? onSelectedProvince;
  final ValueChanged<String?>? onSelectedDistrict;
  final bool enableImagePicker;
  final bool enableInfoExtra;

  NewCustomerForm({
    super.key,
    required this.formKey,
    required this.customerName,
    this.customerLastName,
    required this.dni,
    required this.onImageChanged,
    this.customerPhone,
    this.customerEmail,
    required this.customerAddress,
    this.customerReference,
    this.companyRUC,
    this.companyName,
    this.companyAddress,
    this.companyWeb,
    this.idCompany,
    this.selectedDepartment,
    this.selectedTipoCliente,
    required this.onSelectedTipoCliente,
    required this.selectedTipoDocumento,
    required this.onSelectedTipoDocumento,
    this.selectedProvince,
    this.selectedDistrict,
    this.onSelectedDepartment,
    this.onSelectedProvince,
    this.onSelectedDistrict,
    this.enableImagePicker = true,
    this.enableInfoExtra = true,
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

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Seleccionar de galería'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _selectFile(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Tomar foto con cámara'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _selectFile(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectFile(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      final bytes = await File(image.path).readAsBytes();
      final mimeType = lookupMimeType(image.path);
      final base64Image = 'data:$mimeType;base64,${base64Encode(bytes)}';
      setState(() {
        _selectedImage = image;
      });
      widget.onImageChanged(base64Image);
    }
  }

  @override
  void initState() {
    super.initState();
    selectedDepartment = widget.selectedDepartment;
    selectedProvince = widget.selectedProvince;
    selectedDistrict = widget.selectedDistrict;
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tipoDocumentoProvider = Provider.of<TipoDocumentoProvider>(context);
    if (widget.selectedTipoDocumento == null && tipoDocumentoProvider.tiposDocumento.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSelectedTipoDocumento(tipoDocumentoProvider.tiposDocumento.first.nombre);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<UsersProvider>(context, listen: false).token;
    final departmentsProvider = Provider.of<DepartmentsProvider>(context);
    final tipoClientesProvider = Provider.of<TipoClienteProvider>(context);
    final tipoDocumentoProvider = Provider.of<TipoDocumentoProvider>(context);
    final provincesProvider = Provider.of<ProvincesProvider>(context);
    final districtsProvider = Provider.of<DistrictsProvider>(context);
    final ubigeosProvider = Provider.of<UbigeosProvider>(context, listen: false);

    final tipoDocumento = tipoDocumentoProvider.tiposDocumento.firstWhere(
      (t) => t.nombre == widget.selectedTipoDocumento,
      orElse: () => TipoDocumento(nombre: ''),
    );
    final tipoId = tipoDocumento.id;

    int? getMaxLength() {
      switch (tipoId) {
        case 1: return 8;
        case 2: return 9;
        case 3: return 11;
        case 4: return 9;
        case 5:
        case 6: return null;
        default: return null;
      }
    }

    String? validarDocumento(String? value) {
      if (value == null || value.isEmpty) {
        return 'Por favor, ingresa el número de documento';
      }

      final longitudEsperada = getMaxLength();
      if (longitudEsperada != null && value.length != longitudEsperada) {
        return 'No hay $longitudEsperada caracteres';
      }

      return null;
    }

    TextInputFormatter getInputFormatter() {
      switch (tipoId) {
        case 1:
        case 2:
        case 3:
          return FilteringTextInputFormatter.digitsOnly;
        case 4:
        case 5:
        case 6:
          return FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'));
        default:
          return FilteringTextInputFormatter.allow(RegExp(r'.*'));
      }
    }
    
    Widget _buildDniConIcono() {
      return Row(
        children: [
          Expanded(
            child: _buildTextField(
              controller: widget.dni,
              keyboardType: TextInputType.text,
              validator: validarDocumento,
              hintText: 'N° documento',
              hintStyle: AppTextStyles.base,
              inputFormatters: [
                getInputFormatter(),
                if (getMaxLength() != null)
                  LengthLimitingTextInputFormatter(getMaxLength()),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Buscar cliente',
            onPressed: (tipoId == 1 || tipoId == 3)
                ? () async {
                    final docText = widget.dni.text;

                    if (tipoId == 1 && docText.length == 8) {
                      final resp = await tipoDocumentoProvider
                          .traerDatosPorDni(token!, docText);
                      if (resp['response'] == true) {
                        setState(() {
                          widget.customerName.text = resp['nombre'];
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No se encontró DNI')),
                        );
                      }
                    } else if (tipoId == 3 && docText.length == 11) {
                      final resp = await tipoDocumentoProvider
                          .traerDatosPorRuc(token!, docText);
                      if (resp['response'] == true) {
                        final idUbigeo =
                            int.tryParse(resp['ubigeo'].toString());
                        final ubigeo = ubigeosProvider.ubigeos.firstWhere(
                          (u) => u.id == idUbigeo,
                          orElse: () => Ubigeo(
                            id: 0,
                            ubiDepartamento: '',
                            ubiDistrito: '',
                            ubiProvincia: '',
                          ),
                        );

                        final departamento = ubigeo.ubiDepartamento;
                        final provincia = ubigeo.ubiProvincia;
                        final distrito = ubigeo.ubiDistrito;

                        setState(() {
                          widget.customerName.text = resp['nombre'];
                          widget.customerAddress.text = resp['direccion'];
                          selectedDepartment = departamento;
                          selectedProvince = null;
                          selectedDistrict = null;
                        });

                        await provincesProvider
                            .fetchProvincesByDepartment(departamento, token);
                        await districtsProvider
                            .fetchDistrictsByProvince(provincia, token);

                        setState(() {
                          selectedProvince = provincia;
                          selectedDistrict = distrito;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No se encontró RUC')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Número de documento inválido')),
                      );
                    }
                  }
                : null,
          ),
        ],
      );
    }
    
    bool habilitarCampoByTipo = tipoId != 3;
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.enableInfoExtra
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: BuildSelect(
                  selectedValue: widget.selectedTipoDocumento,
                  options: tipoDocumentoProvider.tiposDocumento
                      .map((d) => d.nombre)
                      .toList(),
                  onChanged: (value) async {
                    setState(() {
                      widget.onSelectedTipoDocumento(value);
                    });
                  },
                  validator: (value) => null,
                  hintText: 'Tipo documento',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: _buildDniConIcono()),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildSelect(
                selectedValue: widget.selectedTipoDocumento,
                options: tipoDocumentoProvider.tiposDocumento
                    .map((d) => d.nombre)
                    .toList(),
                onChanged: (value) async {
                  setState(() {
                    widget.onSelectedTipoDocumento(value);
                  });
                },
                validator: (value) => null,
                hintText: 'Tipo documento',
              ),
              const SizedBox(height: 10),
              _buildDniConIcono(),
            ],
          ),
          const SizedBox(height: 10),
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
                      hintText: 'Nombres de cliente',
                      hintStyle: AppTextStyles.base,
                    ),
                  ],
                ),
              ),
              if (widget.enableImagePicker) ...[
                const SizedBox(width: 16),
                SizedBox(
                  width: 70,
                  height: 70,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _selectedImage!.path.toLowerCase().endsWith('.pdf')
                                ? Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: Icon(Icons.picture_as_pdf,
                                          size: 40, color: Colors.red),
                                    ),
                                  )
                                : Image.file(
                                    File(_selectedImage!.path),
                                    fit: BoxFit.cover,
                                    width: 80,
                                    height: 80,
                                  ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.add_a_photo, color: Colors.grey),
                          ),
                  ),
                ),
              ],
            ],
          ),
          if (widget.enableInfoExtra) ...[
            _buildTextField(
              controller: widget.customerPhone ?? TextEditingController(),
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
              controller: widget.customerEmail ?? TextEditingController(),
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
              hintText: 'Correo Electrónico',
              hintStyle: AppTextStyles.base
            ),
            const SizedBox(height: 07),
          ],
          _buildTextField(
            controller: widget.customerAddress,
            validator: (value) {
              if (widget.enableInfoExtra) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa la dirección';
                }
              }
              return null;
            },
            hintText: 'Dirección...',
            hintStyle: AppTextStyles.base
          ),
          const SizedBox(height: 07),
          if (widget.enableInfoExtra) ...[
            _buildTextField(
              controller: widget.customerReference ?? TextEditingController(),
              validator: (value) {
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
                widget.onSelectedDepartment?.call(value);
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
                      widget.onSelectedProvince?.call(value);
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
                      widget.onSelectedDistrict?.call(value);
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
            const SizedBox(height: 07),
            BuildSelect(
              selectedValue: widget.selectedTipoCliente,
              options: tipoClientesProvider.tiposCliente.map((t) => t.nombre).toList(),
              onChanged: (value) async{
                setState(() {
                  widget.onSelectedTipoCliente(value);;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, selecciona un tipo de cliente';
                }
                return null;
              },
              hintText: 'Tipo de Cliente',
            ),
            const SizedBox(height: 20),
            Text('Datos de la Empresa', style: AppTextStyles.subtitle),
            const SizedBox(height: 07),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: widget.companyRUC ?? TextEditingController(),
                          keyboardType: TextInputType.number,
                          enabled: habilitarCampoByTipo,
                          validator: (value) {
                            if (tipoDocumento == 3) return null;
                            // return null;
                          },
                          hintText: 'RUC',
                          hintStyle: AppTextStyles.base,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.search),
                        tooltip: 'Buscar empresa por RUC',
                        onPressed: (tipoId != 3)
                          ?() async {
                            final rucText = widget.companyRUC?.text ?? '';
                            if (rucText.length == 11) {
                              final resp = await tipoDocumentoProvider.traerDatosPorRuc(token!, rucText);
                              if (resp['response'] == true) {
                                widget.companyName?.text = resp['nombre'];
                                widget.companyAddress?.text = resp['direccion'];
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(resp['mensaje'] ?? 'Error desconocido')),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('El RUC debe tener 11 dígitos')),
                              );
                            }
                          }
                        : null,
                      ),
                    ]
                  )
                ),
              ],
            ),
            const SizedBox(height: 07),
            _buildTextField(
              controller: widget.companyName ?? TextEditingController(),
              enabled: habilitarCampoByTipo,
              validator: (value) {
                if (tipoDocumento == 3) return null;
              },
              hintText: 'Razón Social',
              hintStyle: AppTextStyles.base
            ),
            const SizedBox(height: 07),
            _buildTextField(
              controller: widget.companyAddress ?? TextEditingController(),
              enabled: habilitarCampoByTipo,
              validator: (value) {
                if (tipoDocumento == 3) return null;
              },
              hintText: 'Dirección Fiscal',
              hintStyle: AppTextStyles.base
            ),
            const SizedBox(height: 20),
          ]
        ],
      ),
    );
  }
}

Widget _buildTextField({
  required TextEditingController controller,
  required String? Function(String?) validator,
  bool? enabled,
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
      labelText: hintText,
      labelStyle: AppTextStyles.base,
      hintText: '',
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 5.0),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.lightGris, width: 0.5),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.lightGris, width: 0.5),
      ),
    ),
    enabled: enabled,
    validator: validator,
    onChanged: onChanged,
  );
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
      decoration: InputDecoration(
        isDense: true,
        labelText: hintText,
        labelStyle: AppTextStyles.base,
        contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightGris, width: 0.6),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightGris, width: 0.6),
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