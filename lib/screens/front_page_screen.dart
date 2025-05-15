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
        final isLandscape = screenWidth > screenHeight;

        return Container(
          color: AppColors.orange,
          width: screenWidth,
          height: screenHeight,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight - 64),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FrontLogoSection(isLandscape: isLandscape),
                    const SizedBox(height: 12),
                    FrontActionSection(isLandscape: isLandscape),
                    SizedBox(height: isLandscape ? 24 : 48),
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
  final bool isLandscape;
  const FrontLogoSection({super.key, required this.isLandscape});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final logoWidth = screenWidth * (isLandscape ? 0.6 : 0.8);

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
  final bool isLandscape;
  const FrontActionSection({super.key, required this.isLandscape});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return FractionallySizedBox(
      widthFactor: isSmallScreen ? 0.64 : 0.65,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bienvenidos a SIGAB', style: AppTextStyles.strong),
          const SizedBox(height: 12),
          Text(
            'Sistema Integral de Gestión de Alimentos Balanceados',
            style: AppTextStyles.weak,
          ),
          SizedBox(height: isLandscape ? 32 : 80),
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
              minimumSize: const Size(double.infinity, 42),
            ),
            child: Text('Ingresar', style: AppTextStyles.login),
          ),
          SizedBox(height: isLandscape ? 12 : 20),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewUserScreen()),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.white),
              ),
              minimumSize: const Size(double.infinity, 42),
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
      color: AppColors.gris,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      decoration: TextDecoration.none,
  );
  static final weak = base.copyWith(fontWeight: FontWeight.w300);
  static final strong = base.copyWith(fontWeight: FontWeight.w600, fontSize: 20);
  static final login = base.copyWith(color: AppColors.orange);
  static final register = base.copyWith(color: Colors.white);
}

class AppColors {
  static const orange = Color(0xFFFF6600);
  static const gris = Color(0xFF333333);
}

