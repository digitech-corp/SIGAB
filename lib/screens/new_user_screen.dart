import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NewUserScreen(),
    );
  }
}

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({super.key});

  @override
  State<NewUserScreen> createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userName = TextEditingController();
  final _userPassword = TextEditingController();

  @override
  void dispose() {
    _userName.dispose();
    _userPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF6600),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(64),
                bottomRight: Radius.circular(64),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  IconButton(icon: Icon(Icons.arrow_back_ios), color: Color(0xFFFF6600), onPressed: () {Navigator.pop(context);}),
                  const SizedBox(height: 20),
                  Container(
                    width: 290,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Nuevo Usuario',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xFF333333),
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Registra tus datos para crear un usuario usando tu cuenta de correo corporativo',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xFF333333),
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Formulario
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nombre Completo',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            color: Color(0xFFFF6600),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _buildTextField(
                          controller: _userName,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa un nombre de usuario';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'N° Documento de Identidad - DNI',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            color: Color(0xFFFF6600),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _buildTextField(
                          controller: _userPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa una contraseña';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Correo Corporativo',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            color: Color(0xFFFF6600),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _buildTextField(
                          controller: _userPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa una contraseña';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Contraseña',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            color: Color(0xFFFF6600),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _buildTextField(
                          controller: _userPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa una contraseña';
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Confirmar Contraseña',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            color: Color(0xFFFF6600),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _buildTextField(
                          controller: _userPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa una contraseña';
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 35),
          // Botones
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Registrado correctamente")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: Color(0xFFFF6600),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 14,
        color: Color(0xFF333333),
        fontWeight: FontWeight.w300,
      ),
      obscureText: obscureText,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 5.0),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFFF6600)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFFF6600), width: 2.0),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFFF6600)),
        ),
      ),
      validator: validator,
    );
  }
}
