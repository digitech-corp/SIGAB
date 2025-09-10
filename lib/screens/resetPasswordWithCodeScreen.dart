import 'package:balanced_foods/providers/users_provider.dart';
import 'package:balanced_foods/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordWithCodeScreen extends StatefulWidget {
  final String email;

  const ResetPasswordWithCodeScreen({super.key, required this.email});

  @override
  State<ResetPasswordWithCodeScreen> createState() => _ResetPasswordWithCodeScreenState();
}

class _ResetPasswordWithCodeScreenState extends State<ResetPasswordWithCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.orange,
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.orange,
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
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 80),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Text('Establecer Nueva Contraseña', style: AppTextStyles.title, textAlign: TextAlign.center,),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        // enabled: false,
                        decoration: const InputDecoration(labelText: "Correo electrónico", labelStyle: AppTextStyles.base),
                        style: AppTextStyles.base,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _codeController,
                        decoration: const InputDecoration(labelText: "Código de verificación (Revise su correo)", labelStyle: AppTextStyles.base),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese el código';
                          }
                          return null;
                        },
                        style: AppTextStyles.base,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: "Nueva contraseña", labelStyle: AppTextStyles.base),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese nueva contraseña';
                          }
                          return null;
                        },
                        style: AppTextStyles.base,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: "Confirmar nueva contraseña", labelStyle: AppTextStyles.base),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirme la contraseña';
                          }
                          if (value != _passwordController.text) {
                            return 'Las contraseñas no coinciden';
                          }
                          return null;
                        },
                        style: AppTextStyles.base,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            usersProvider
                                .setNewPassword(
                                  _emailController.text,
                                  _codeController.text,
                                  _passwordController.text,
                                )
                                .then((msg) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                              if (msg.contains("restablecida") || msg.contains("exito")) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                                  (route) => false,
                                );
                              }
                            });
                          }
                        },
                        child: Text("Guardar nueva contraseña", style: AppTextStyles.white),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            usersProvider.recoverPassword(_emailController.text).then((result) {
                              final String message = result['message'];
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                            });
                          },
                          child: Text(
                            "Reenviar código",
                            style: AppTextStyles.subrayado
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
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
  static final title = base.copyWith(color: AppColors.gris, fontSize: 20, fontWeight: FontWeight.w600);
  static final strong = base.copyWith(fontWeight: FontWeight.w700, fontSize: 20, decoration: TextDecoration.none);
  static final orange = base.copyWith(color: AppColors.orange);
  static final subrayado = base.copyWith(color: AppColors.orange, decoration: TextDecoration.underline);
  static final white = base.copyWith(color: Colors.white);
  static final controller = base.copyWith();
}

class AppColors {
  static const orange = Color(0xFFFF6600);
  static const gris = Color(0xFF333333);
}

