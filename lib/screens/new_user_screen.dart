import 'package:balanced_foods/models/user.dart';
import 'package:balanced_foods/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:balanced_foods/screens/login_screen.dart';
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
  final _name = TextEditingController();
  final _dni = TextEditingController();
  final _email = TextEditingController();
  final _userPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _dni.dispose();
    _email.dispose();
    _userPassword.dispose();
    _confirmPassword.dispose();
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
                  const SizedBox(height: 20),
                  // Header
                  const NewUserHeader(),
                  const SizedBox(height: 30),
                  // Formulario
                  NewUserForm(
                    formKey: _formKey,
                    name: _name,
                    dni: _dni,
                    email: _email,
                    userPassword: _userPassword,
                    confirmPassword: _confirmPassword,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 35),
          // Botones
          RegisterButton(
            formKey: _formKey,
            name: _name,
            dni: _dni,
            email: _email,
            userPassword: _userPassword,
          ),
        ],
      ),
    );
  }
}

class NewUserHeader extends StatelessWidget {
  const NewUserHeader({super.key});

  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: 290,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nuevo Usuario', style: AppTextStyles.strong),
          const SizedBox(height: 8),
          Text('Registra tus datos para crear un usuario usando tu cuenta de correo corporativo', style: AppTextStyles.weak),
        ],
      ),
    );
  }
}

class NewUserForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController  name;
  final TextEditingController  dni;
  final TextEditingController  email;
  final TextEditingController  userPassword;
  final TextEditingController  confirmPassword;
  
   const NewUserForm({
     super.key,
     required this.formKey,
     required this.name,
     required this.dni,
     required this.email,
     required this.userPassword,
     required this.confirmPassword,
   });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nombre Completo', style: AppTextStyles.orange),
          _buildTextField(
            controller: name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa tu nombre completo';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          Text('N° Documento de Identidad - DNI', style: AppTextStyles.orange),
          _buildTextField(
            controller: dni,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa tu DNI';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          Text('Correo Corporativo', style: AppTextStyles.orange),
          _buildTextField(
            controller: email,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa tu correo corporativo';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          Text('Contraseña', style: AppTextStyles.orange),
          _buildTextField(
            controller: userPassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa tu contraseña';
              }
              return null;
            },
            obscureText: true,
          ),
          const SizedBox(height: 30),
          Text('Confirmar Contraseña', style: AppTextStyles.orange),
          _buildTextField(
            controller: confirmPassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, repite la contraseña';
              }
              if (value != userPassword.text) {
                return 'Las contraseñas no coinciden';
              }
              return null;
            },
            obscureText: true,
          ),
          const SizedBox(height: 20),
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
      controller: controller, style: AppTextStyles.controller,
      obscureText: obscureText,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 5.0),
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

class RegisterButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController name;
  final TextEditingController dni;
  final TextEditingController email;
  final TextEditingController userPassword;

  const RegisterButton({
    super.key,
    required this.formKey,
    required this.name,
    required this.dni,
    required this.email,
    required this.userPassword,
  });
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.15;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final provider = Provider.of<UsersProvider>(context, listen: false);
                  final newUser = User(
                    name: name.text,
                    dni: dni.text,
                    email: email.text,
                    password: userPassword.text,
                  );

                  final success = await provider.registerUser(newUser);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Registrado correctamente")),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Error al registrar")),
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
              child: Text('Registrarse', style: AppTextStyles.register),
            ),
          ),
        ],
      ),
    );
  }
}

class AppTextStyles {
  static const base = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: AppColors.orange
  );
  static final strong = base.copyWith(color: AppColors.gris,fontWeight: FontWeight.w600,fontSize: 20,decoration: TextDecoration.none);
  static final weak = base.copyWith(color: AppColors.gris,fontWeight: FontWeight.w300,decoration: TextDecoration.none);
  static final orange = base.copyWith();
  static final register = base.copyWith();
  static final controller = base.copyWith(color: AppColors.gris,fontWeight: FontWeight.w300);
}

class AppColors {
  static const orange = Color(0xFFFF6600);
  static const gris = Color(0xFF333333);
}