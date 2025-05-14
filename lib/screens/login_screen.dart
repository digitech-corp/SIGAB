import 'package:flutter/material.dart';
import 'package:balanced_foods/screens/new_user_screen.dart';
import 'package:balanced_foods/screens/recover_password_screen.dart';
import 'package:balanced_foods/screens/sales_module_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFF6600),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                Container(
                  height: screenHeight * 0.65,
                  width: screenWidth,
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
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          color: const Color(0xFFFF6600),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(height: 25),
                        const LoginHeader(),
                        const SizedBox(height: 30),
                        LoginForm(
                          formKey: _formKey,
                          userName: _userName,
                          userPassword: _userPassword,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 55),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.15),
                  child: LoginButtons(formKey: _formKey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Buen día', style: AppTextStyles.strong),
            const SizedBox(height: 12),
            Text(
              'Ingresa tu usuario y contraseña para acceder a tu cuenta',
              style: AppTextStyles.weak,
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController userName;
  final TextEditingController userPassword;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.userName,
    required this.userPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Usuario', style: AppTextStyles.orange),
          _buildTextField(
            controller: userName,
            validator: (value) =>
                value == null || value.isEmpty ? 'Por favor, ingresa un nombre de usuario' : null,
          ),
          const SizedBox(height: 40),
          Text('Contraseña', style: AppTextStyles.orange),
          _buildTextField(
            controller: userPassword,
            validator: (value) =>
                value == null || value.isEmpty ? 'Por favor, ingresa una contraseña' : null,
            obscureText: true,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Transform.scale(
                    scale: 0.80,
                    child: Checkbox(
                      value: true,
                      onChanged: (_) {},
                      activeColor: const Color(0xFFFF6600),
                      shape: const CircleBorder(),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                    ),
                  ),
                  Text('Recordarme', style: AppTextStyles.remember),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecoverPasswordScreen()),
                  );
                },
                child: Text('¿Olvidaste tu contraseña?', style: AppTextStyles.orange),
              ),
            ],
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
        fontWeight: FontWeight.w500,
      ),
      obscureText: obscureText,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 9.0),
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

class LoginButtons extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const LoginButtons({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final horizontalPadding = screenWidth * 0.0;

  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 480),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Validación exitosa")),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SalesModuleScreen()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Iniciar Sesión', style: AppTextStyles.orange),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Registrado correctamente")),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewUserScreen()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
                child: Text('Registrarse', style: AppTextStyles.register),
              ),
            ),
          ],
        ),
      ),
  );
  }
}

class AppTextStyles {
  static const base = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    decoration: TextDecoration.none,
  );
  static final weak = base.copyWith(color: Color(0xFF333333), fontWeight: FontWeight.w300);
  static final strong = base.copyWith(color: Color(0xFF333333), fontWeight: FontWeight.w600, fontSize: 20);
  static final orange = base.copyWith(color: Color(0xFFFF6600));
  static final remember = base.copyWith(color: Colors.black);
  static final register = base.copyWith(color: Colors.white);
}