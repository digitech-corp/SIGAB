import 'package:flutter/material.dart';
import 'package:balanced_foods/screens/login_screen.dart';
import 'package:balanced_foods/screens/new_user_screen.dart';

class FrontPage extends StatelessWidget {
  const FrontPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFF6600),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Contenedor de la imagen
          Container(
            width: 365,
            height: 140,
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.cover,
            ),
          ),
          // Contenedor de la información
          Container(
            width: 282,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 220,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bienvenidos a SIGAB',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Sistema Integral de Gestión de Alimentos Balanceados',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 80),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // if (_formKey.currentState!.validate()) {
                      //   Navigator.pop(context);
                      // }
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Ingresar',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: Color(0xFFFF6600),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // if (_formKey.currentState!.validate()) {
                      //   Navigator.pop(context);
                      // }
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewUserScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF6600), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      'Registrarse',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: Colors.white,
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
}
