import 'package:balanced_foods/providers/users_provider.dart';
import 'package:balanced_foods/screens/modulo_transportistas/transport_screen.dart';
import 'package:flutter/material.dart';
import 'package:balanced_foods/screens/new_user_screen.dart';
import 'package:balanced_foods/screens/recover_password_screen.dart';
import 'package:balanced_foods/screens/sales_module_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  @override
  void dispose() {
    _userName.dispose();
    _userPassword.dispose();
    super.dispose();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool('remember_me') ?? false;
    if (remember) {
      setState(() {
        _rememberMe = true;
        _userName.text = prefs.getString('saved_username') ?? '';
      });
    }
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', _rememberMe);
    if (_rememberMe) {
      await prefs.setString('saved_username', _userName.text.trim());
    } else {
      await prefs.remove('saved_username');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;
    // Users();
    return Scaffold(
      backgroundColor: const Color(0xFFFF6600),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints(minHeight: isLandscape ? 340 : 500),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(64),
                    bottomRight: Radius.circular(64),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth*0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: isLandscape ? 8 : 40),
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        color: const Color(0xFFFF6600),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(height: isLandscape ? 5 : 25),
                      const LoginHeader(),
                      SizedBox(height: isLandscape ? 16 : 30),
                      LoginForm(
                        formKey: _formKey,
                        userName: _userName,
                        userPassword: _userPassword,
                        rememberMe: _rememberMe,
                        onRememberMeChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: isLandscape ? 16 : 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.15),
                child: LoginButtons(
                    formKey: _formKey,
                    userName: _userName,
                    userPassword: _userPassword,
                    rememberMe: _rememberMe,
                    onSaveCredentials: _saveCredentials,
                  ),
              ),
            ],
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Buen día', style: AppTextStyles.strong),
          SizedBox(height: isLandscape ? 2 : 12),
          Text(
            'Ingresa tu usuario y contraseña para acceder a tu cuenta',
            style: AppTextStyles.weak,
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController userName;
  final TextEditingController userPassword;
  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.userName,
    required this.userPassword,
    required this.rememberMe,
    required this.onRememberMeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Usuario', style: AppTextStyles.orange),
          _buildTextField(
            context: context,
            controller: userName,
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
          ),
          SizedBox(height: isLandscape ? 20 : 40),
          Text('Contraseña', style: AppTextStyles.orange),
          _buildTextField(
            context: context,
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
                      value: rememberMe,
                      onChanged: onRememberMeChanged,
                      activeColor: const Color(0xFFFF6600),
                      shape: const CircleBorder(),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                    ),
                  ),
                  const SizedBox(width: 8),
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
    required BuildContext context,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool obscureText = false,
  }) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 14,
        color: Color(0xFF333333),
        fontWeight: FontWeight.w500,
      ),
      obscureText: obscureText,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: isLandscape ? 5 : 9.0),
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
  final TextEditingController userName;
  final TextEditingController userPassword;
  final bool rememberMe;
  final Future<void> Function() onSaveCredentials;

  const LoginButtons({
    super.key,
    required this.formKey,
    required this.userName,
    required this.userPassword,
    required this.rememberMe,
    required this.onSaveCredentials,
  });

  @override
  Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final horizontalPadding = screenWidth * 0.0;
  final screenHeight = MediaQuery.of(context).size.height;
  final isLandscape = screenWidth > screenHeight;
  
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 480),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final userProvider = Provider.of<UsersProvider>(context, listen: false);
                    final user  = await userProvider.validateUser(
                      userName.text.trim(),
                      userPassword.text.trim(),
                    );

                    if (user  != null) {
                      await onSaveCredentials();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Inicio de sesión exitoso")),
                      );
                      final role = user.role.toUpperCase().trim();
                      if (role == 'VENDEDOR') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SalesModuleScreen()),
                        );
                      } else if (role == 'TRANSPORTISTA') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => TransportScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Rol no reconocido")),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Usuario o contraseña incorrectos")),
                      );
                    }
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
            SizedBox(height: isLandscape ? 5 : 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewUserScreen()),
                  );
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
            SizedBox(height: isLandscape ? 10 : 10),
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
    color: Color(0xFF333333),
    decoration: TextDecoration.none,
  );
  static final weak = base.copyWith(fontWeight: FontWeight.w300);
  static final strong = base.copyWith(fontWeight: FontWeight.w600, fontSize: 20);
  static final orange = base.copyWith(color: Color(0xFFFF6600));
  static final remember = base.copyWith(color: Colors.black);
  static final register = base.copyWith(color: Colors.white);
}