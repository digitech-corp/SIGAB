import 'package:balanced_foods/providers/users_provider.dart';
import 'package:balanced_foods/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetNewPasswordScreen extends StatefulWidget {
  final String email;
  final String code;

  const SetNewPasswordScreen({super.key, required this.email, required this.code});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);

    return Scaffold(
      body: Column(
        children: [
          Text("Nueva contraseña para ${widget.email}"),
          TextField(controller: _passwordController, obscureText: true),
          ElevatedButton(
            onPressed: () {
              if (_passwordController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Ingrese nueva contraseña")),
                );
              } else {
                usersProvider
                    .setNewPassword(widget.email, widget.code, _passwordController.text)
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
            child: const Text("Guardar nueva contraseña"),
          ),
        ],
      ),
    );
  }
}


