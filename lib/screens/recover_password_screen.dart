import 'package:balanced_foods/providers/users_provider.dart';
import 'package:balanced_foods/screens/resetPasswordWithCodeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RecoverPasswordScreen(),
    );
  }
}

class RecoverPasswordScreen extends StatefulWidget {
  const RecoverPasswordScreen({super.key});

  @override
  State<RecoverPasswordScreen> createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
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
    final screenWidth = MediaQuery.of(context).size.width;
    final bodyPadding = screenWidth * 0.06;
    return Scaffold(
      backgroundColor: AppColors.orange,
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
              padding: EdgeInsets.symmetric(horizontal: bodyPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  IconButton(icon: Icon(Icons.arrow_back_ios), color: AppColors.orange, onPressed: () {Navigator.pop(context);}),
                  const SizedBox(height: 25),
                  Container(
                    width: 290,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Recuperar Contraseña', style: AppTextStyles.strong),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                  // Formulario
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ingrese su correo electrónico', style: AppTextStyles.orange),
                        _buildTextField(
                          controller: _userName,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa un nombre de usuario';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 50),
                        Center(
                          child: SizedBox(
                            width: 280,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final usersProvider = Provider.of<UsersProvider>(context, listen: false);
                                  usersProvider.recoverPassword(_userName.text).then((result) {
                                    final bool state = result['response'];
                                    final String message = result['message'];
                                    if (state) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => ResetPasswordWithCodeScreen(email: _userName.text)),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                                    }
                                  });
                                  
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text('Restablecer contraseña', style: AppTextStyles.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 55),
                      ],
                    ),
                  ),
                ],
              ),
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
      style: AppTextStyles.controller,
      obscureText: obscureText,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 9.0),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.orange),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.orange, width: 2.0),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.orange),
        ),
      ),
      validator: validator,
    );
  }
}

class AppTextStyles {
  static const base = TextStyle(
    fontFamily: 'Montserrat',
      color: AppColors.gris,
      fontWeight: FontWeight.w500,
      fontSize: 14,
  );
  static final strong = base.copyWith(fontWeight: FontWeight.w700, fontSize: 20, decoration: TextDecoration.none);
  static final orange = base.copyWith(color: AppColors.orange);
  static final white = base.copyWith(color: Colors.white);
  static final controller = base.copyWith();
}

class AppColors {
  static const orange = Color(0xFFFF6600);
  static const gris = Color(0xFF333333);
}

