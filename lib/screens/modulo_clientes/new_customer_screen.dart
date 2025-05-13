import 'package:balanced_foods/screens/sales_module_screen.dart';
import 'package:flutter/material.dart';

class NewCustomerScreen extends StatefulWidget {
  final bool showSuccess;

  const NewCustomerScreen({super.key, this.showSuccess = false});

  @override
  State<NewCustomerScreen> createState() => _NewCustomerScreenState();
}

class _NewCustomerScreenState extends State<NewCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userName = TextEditingController();
  final _userPassword = TextEditingController();
  String? selectedOption;

  @override
  void dispose() {
    _userName.dispose();
    _userPassword.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.showSuccess) {
      Future.microtask(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Se ha añadido exitosamente",
              style: TextStyle(fontSize: 14, fontFamily: 'Montserrat'),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
      });
    }
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SalesModuleScreen()),
                    );
                  },
                ),
                const SizedBox(width: 1),
                const Text(
                  'Registrar Nuevo Cliente',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
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
              Text(
                'Identificación Personal',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 07),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _userName,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa un nombre de usuario';
                              }
                              return null;
                            },
                            hintText: 'p. ej. Alfredo Fiestas',
                            hintStyle: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: Color(0xFFBDBDBD),
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/images/add_picture.png',
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                        ),
                      ],
                    ),
                    const SizedBox(height: 07),
                    _buildTextField(
                      controller: _userPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa una contraseña';
                        }
                        return null;
                      },
                      hintText: 'Celular',
                    ),
                    const SizedBox(height: 07),
                    _buildTextField(
                      controller: _userPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa una contraseña';
                        }
                        return null;
                      },
                      hintText: 'Correo Electrónico',
                    ),
                    const SizedBox(height: 07),
                    _buildTextField(
                      controller: _userPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa una contraseña';
                        }
                        return null;
                      },
                      hintText: 'Dirección...',
                    ),
                    const SizedBox(height: 07),
                    _buildTextField(
                      controller: _userPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa una contraseña';
                        }
                        return null;
                      },
                      hintText: 'Referencia',
                    ),
                    const SizedBox(height: 07),
                    _buildSelect(
                      selectedValue: selectedOption,
                      options: ['Opción 1', 'Opción 2', 'Opción 3'],
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa una contraseña';
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
                            selectedValue: selectedOption,
                            options: ['Opción 1', 'Opción 2', 'Opción 3'],
                            onChanged: (value) {
                              setState(() {
                                selectedOption = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa una contraseña';
                              }
                              return null;
                            },
                            hintText: 'Provincia',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildSelect(
                            selectedValue: selectedOption,
                            options: ['Opción 1', 'Opción 2', 'Opción 3'],
                            onChanged: (value) {
                              setState(() {
                                selectedOption = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa una contraseña';
                              }
                              return null;
                            },
                            hintText: 'Distrito',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Datos de la Empresa',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 07),
                    _buildTextField(
                      controller: _userPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa una contraseña';
                        }
                        return null;
                      },
                      hintText: 'RUC',
                    ),
                    const SizedBox(height: 07),
                    _buildTextField(
                      controller: _userPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa una contraseña';
                        }
                        return null;
                      },
                      hintText: 'Razón Social',
                    ),
                    const SizedBox(height: 07),
                    _buildTextField(
                      controller: _userPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa una contraseña';
                        }
                        return null;
                      },
                      hintText: 'Dirección Fiscal',
                    ),
                    const SizedBox(height: 07),
                    _buildTextField(
                      controller: _userPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa una contraseña';
                        }
                        return null;
                      },
                      hintText: 'Sitio Web',
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: 282,
                        height: 37,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                               ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    "Se ha añadido exitosamente",
                                    style: TextStyle(fontSize: 14, fontFamily: 'Montserrat'),
                                  ),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 5),
                                  margin: const EdgeInsets.all(16),
                                ),
                              );
                              Future.delayed(const Duration(seconds: 5), () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewCustomerScreen(showSuccess: true),
                                  ),
                                );
                              });
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => NewCustomerScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: Color(0xFFFF6600), 
                                width: 1, 
                              ),
                            ),
                          ),
                          child: const Text(
                            'Añadir Contacto',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: Color(0xFFFF6600),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool obscureText = false,
    String? hintText,
    TextStyle? hintStyle,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16,
        color: Color(0xFF333333),
        fontWeight: FontWeight.w300,
      ),
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle ??
          const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: Color(0xFFBDBDBD),
          ),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 5.0),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 0.5),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 0.5),
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
      style: const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16,
        color: Color(0xFF333333),
        fontWeight: FontWeight.w300,
      ),
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 5.0),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 0.5),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 0.5),
        ),
      ),
      hint: Text(
        hintText ?? '',
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: Color(0xFFBDBDBD),
        ),
      ),
      validator: validator,
      items: options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: Color(0xFF333333),
              fontWeight: FontWeight.w300,
            ),
          ),
        );
      }).toList(),
    );
  }
}