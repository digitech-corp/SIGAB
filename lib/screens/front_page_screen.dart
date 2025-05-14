import 'package:flutter/material.dart';
import 'package:balanced_foods/screens/login_screen.dart';
import 'package:balanced_foods/screens/new_user_screen.dart';

class FrontPage extends StatelessWidget {
  const FrontPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        return Container(
          color: const Color(0xFFFF6600),
          width: screenWidth,
          height: screenHeight,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight - 64, // 64 = padding vertical * 2
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    FrontLogoSection(),
                    SizedBox(height: 12),
                    FrontActionSection(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FrontLogoSection extends StatelessWidget {
  const FrontLogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final logoWidth = screenWidth * 0.8; // 70% del ancho de pantalla

    return SizedBox(
      width: logoWidth,
      child: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.contain,
      ),
    );
  }
}

class FrontActionSection extends StatelessWidget {
  const FrontActionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return FractionallySizedBox(
      widthFactor: isSmallScreen ? 0.64 : 0.65, // ancho adaptado
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenidos a SIGAB',
            style: AppTextStyles.strong,
          ),
          const SizedBox(height: 12),
          Text(
            'Sistema Integral de Gestión de Alimentos Balanceados',
            style: AppTextStyles.weak,
          ),
          const SizedBox(height: 80),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: Size(double.infinity, 42),
            ),
            child: Text('Ingresar', style: AppTextStyles.login),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewUserScreen()),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6600),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.white),
              ),
              minimumSize: Size(double.infinity, 42),
            ),
            child: Text('Registrarse', style: AppTextStyles.register),
          ),
        ],
      ),
    );
  }
}

class AppTextStyles {
  static const base = TextStyle(
    fontFamily: 'Montserrat',
      color: Color(0xFF333333),
      fontWeight: FontWeight.w500,
      fontSize: 14,
      decoration: TextDecoration.none,
  );
  static final weak = base.copyWith(fontWeight: FontWeight.w300);
  static final strong = base.copyWith(fontWeight: FontWeight.w600, fontSize: 20);
  static final login = base.copyWith(color: Color(0xFFFF6600));
  static final register = base.copyWith(color: Colors.white);
}

